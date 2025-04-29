class AnswersController < ApplicationController
  include VotableController

  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[edit update destroy]
  before_action :set_question_from_answer, only: %i[update destroy]
  before_action -> { authorize_user!(@answer) }, only: %i[edit update destroy]

  def new
    @answer = @question.answers.new
    @links = @answer.links.new
  end

  def create
    @answer = @question.answers.build(answer_params).tap { |answer| answer.author = current_user }

    if @answer.save
      ActionCable.server.broadcast("answers_question_#{@question.id}_channel_authenticated",
                                   { question_html: render_answer(authenticated: true), action: "create" })

      ActionCable.server.broadcast("answers_question_#{@question.id}_channel_unauthenticated",
                                   { question_html: render_answer(authenticated: false), action: "create" })

      turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @links = @answer.links.presence || @answer.links.new
  end

  def update
    if @answer.update(answer_params)
      ActionCable.server.broadcast("answers_question_#{@question.id}_channel_authenticated",
                                   { answer_html: render_answer(authenticated: true),
                                     action: "update", answer_id: @answer.id })

      ActionCable.server.broadcast("answers_question_#{@question.id}_channel_unauthenticated",
                                   { answer_html: render_answer(authenticated: false),
                                     action: "update", answer_id: @answer.id })

      turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    ActionCable.server.broadcast("answers_question_#{@question.id}_channel_authenticated",
                                 { answer_html: render_answer(authenticated: true),
                                   action: "destroy", answer_id: @answer.id })

    ActionCable.server.broadcast("answers_question_#{@question.id}_channel_unauthenticated",
                                 { answer_html: render_answer(authenticated: false),
                                   action: "destroy", answer_id: @answer.id })

    @answer.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_question_from_answer
    @question = @answer.question
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                   links_attributes: [ :name, :url, :id, :_destroy ])
  end

  def render_answer(authenticated)
    ApplicationController.renderer.render(
      partial: "answers/channels/answer",
      locals: { answer: @answer, question: @question, authenticated: authenticated }
    )
  end
end
