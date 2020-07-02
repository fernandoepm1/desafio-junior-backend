class Api::V1::ApiController < ActionController::API
  include ResponseManager
  include ExceptionHandler

  respond_to :json
  before_action :check_basic_auth

  private

  def check_basic_auth
    if request.authorization.blank?
      head :unauthorized
      return
    end

    # Try to find user by token
    token = request.authorization
    user = User.find_by(token: token)

    if user
      @current_user = user
    else
      head :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
