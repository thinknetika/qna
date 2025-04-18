# app/controllers/concerns/votable_controller.rb
module VotableController
  extend ActiveSupport::Concern

  included do
    def vote
      @votable = find_votable

      if @votable.respond_to?(:author) && @votable.author == current_user
        render json: { error: "You cannot vote for your own content." }, status: :forbidden
        return
      end

      vote = @votable.votes.find_or_initialize_by(user: current_user)

      if vote.persisted?
        if vote.value == params[:value].to_i
          vote.value = 0
          # render json: { error: "You have already voted this way." }, status: :unprocessable_entity
        else
          vote.value = params[:value]
        end
      else
        vote.value = params[:value]
      end

      if vote.save
        render json: { rating: @votable.rating, voted: vote.value != 0, vote_value: vote.value }, content_type: "application/json"
      else
        render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity, content_type: "application/json"
      end
    end

    private

    def find_votable
      name = self.class.name.chomp("Controller").singularize.underscore
      klass = name.classify.constantize
      @votable = klass.find(params[:id])
    rescue NameError, ActiveRecord::RecordNotFound
      render json: { error: "Invalid votable type or ID" }, status: :unprocessable_entity, content_type: "application/json"
      return
    end
  end
end
