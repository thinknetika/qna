module Api
  module V1
    class AnswersController < BaseController
      before_action :answer, only: [:show, :update, :destroy]
      before_action :question, only: [:create]

      def index
        answers = policy_scope(Answer).where(question_id: params[:question_id])

        render json: answers
      end

      def show
        render json: @answer
      end

      def create
        @answer = @question.answers.build(answer_params).tap { |answer| answer.author = current_user }

        authorize @answer

        if @answer.save
          render json: @answer, status: :created
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @answer

        if @answer.update(answer_params)
          render json: @answer
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @answer

        @answer.destroy

        head :no_content
      end

      private

      def answer
        @answer ||= Answer.find(params[:id])
      end

      def question
        @question ||= Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
