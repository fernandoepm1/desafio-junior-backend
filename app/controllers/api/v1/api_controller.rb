class Api::V1::ApiController < ActionController::API
  include ResponseManager
  include ExceptionHandler

  respond_to :json
  before_action :check_basic_auth

  private

  def check_basic_auth
    if request.authorization.blank?
      msg = 'Missing Authorization token'
      json_renderer({ error: { message: msg } }, :unauthorized)
      return
    else
      # Try to find user by token
      token = request.authorization
      user = User.find_by(token: token)
    end

    if user
      @current_user = user
    else
      msg = 'Invalid token provided'
      json_renderer({ error: { message: msg } }, :unauthorized)
    end
  end

  def current_user
    @current_user
  end
end
