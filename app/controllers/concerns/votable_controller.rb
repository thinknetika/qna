# app/controllers/concerns/votable_controller.rb
module VotableController
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[ vote ]
    before_action :votable_author!, only: %i[ vote ]

    def vote
      vote = Vote.create_or_update_vote(@votable, current_user, params[:value].to_i)

      if vote.save
        render json: { rating: @votable.rating, vote_value: vote.value }, content_type: "application/json"
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

    def votable_author!
      if @votable.author == current_user
        render json: { error: "You cannot vote for your own content." }, status: :forbidden
        return
      end
    end
  end
end
