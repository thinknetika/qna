class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize current_user, policy_class: ProfilePolicy

    render json: current_user, serializer: ProfileSerializer
  end

  def index
    users = User.where.not(id: current_user.id)

    authorize users, policy_class: ProfilePolicy

    render json: users, each_serializer: ProfileSerializer
  end
end
