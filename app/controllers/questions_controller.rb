class QuestionsController < ApplicationController
  include QuestionsHelper
  include VotableController

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]

  def index
    @questions = policy_scope(Question)
    @user_rewards = UserReward.for_user(current_user) if current_user
  end

  def show; end

  def new
    @question = Question.new

    authorize @question

    @links = @question.links.new
    @reward = @question.build_reward

  end

  def create
    @question = current_user.questions.new(question_params)

    authorize @question

    if @question.save
      Broadcaster.broadcast(
        "questions_channel",
        "questions/channels/create",
        locals: { question: @question }
      )

      turbo_stream
    else
      render :new
    end
  end

  def edit
    authorize @question

    @links = @question.links.presence || @question.links.new
    @reward = @question.reward.presence || @question.build_reward
  end

  def update
    authorize @question

    if @question.update(question_params)
      Broadcaster.broadcast(
        "questions_channel",
        "questions/channels/create",
        locals: { question: @question }
      )

      turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @question

    @question.destroy

    Broadcaster.broadcast(
      "questions_channel",
      "questions/channels/destroy",
      locals: { question: @question }
    )

    if show_view(@question)
      redirect_to (questions_path), status: :see_other
    else
      turbo_stream
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title, :body, files: [],
      links_attributes: [:name, :url, :id, :_destroy],
      reward_attributes: [:title, :image, :id, :_destroy]
    )
  end

  def render_question(authenticated)
    ApplicationController.renderer.render(
      partial: "questions/channels/question",
      locals: { question: @question, authenticated: authenticated }
    )
  end
end
