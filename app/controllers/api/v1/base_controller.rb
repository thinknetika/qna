class Api::V1::BaseController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :doorkeeper_authorize!
  before_action :set_current_user

  private

  def current_user
    return unless doorkeeper_token

    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def set_current_user
    @current_user = current_user
  end
end
