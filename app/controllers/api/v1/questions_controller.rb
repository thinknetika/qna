class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update destroy]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_user.questions.new(question_params)

    authorize @question

    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize @question

    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @question

    @question.destroy

    head :no_content
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title, :body,
      links_attributes: [:name, :url, :id, :_destroy],
      reward_attributes: [:title, :image, :id, :_destroy]
    )
  end
end
