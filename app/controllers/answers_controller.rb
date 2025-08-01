class AnswersController < ApplicationController
  include VotableController

  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[edit update destroy]
  before_action :set_question_from_answer, only: %i[update destroy]

  def new
    @answer = @question.answers.new
    @links = @answer.links.new

    authorize @answer
  end

  def create
    @answer = @question.answers.build(answer_params).tap { |answer| answer.author = current_user }

    authorize @answer

    if @answer.save
      Broadcaster.broadcast(
        "answers_channel",
        "answers/channels/create",
        locals: { answer: @answer }
      )

      AnswerNotificationJob.perform_later(@answer)

      turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @answer

    @links = @answer.links.presence || @answer.links.new
  end

  def update
    authorize @answer

    if @answer.update(answer_params)
      Broadcaster.broadcast(
        "answers_channel",
        "answers/channels/update",
        locals: { answer: @answer }
      )

      turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Broadcaster.broadcast(
      "answers_channel",
      "answers/channels/destroy",
      locals: { answer: @answer }
    )

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
