class Api::V1::ApiController < ActionController::Base
  before_action :verify_auth_token

  private

  def verify_auth_token
    # TODO: Check user generated token
  end
end
