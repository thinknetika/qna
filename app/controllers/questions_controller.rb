class QuestionsController < ApplicationController
  include QuestionsHelper
  include VotableController

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  before_action -> { authorize_user!(@question) }, only: %i[edit update destroy]

  def index
    @questions = Question.all
    @user_rewards = UserReward.for_user(current_user) if current_user
  end

  def show; end

  def new
    @question = Question.new
    @links = @question.links.new
    @reward = @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      QuestionBroadcaster.broadcast(@question, "create")

      turbo_stream
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @links = @question.links.presence || @question.links.new
    @reward = @question.reward.presence || @question.build_reward
  end

  def update
    if @question.update(question_params)
      QuestionBroadcaster.broadcast(@question, "update")

      turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy

    QuestionBroadcaster.broadcast(@question, "destroy")

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

  def authorize_question!
    unless current_user&.owns?(@question)
      redirect_to questions_path(@question), alert: "You are not authorized to perform this action.", status: :see_other
    end
  end

  def render_question(authenticated)
    ApplicationController.renderer.render(
      partial: "questions/channels/question",
      locals: { question: @question, authenticated: authenticated }
    )
  end
end
