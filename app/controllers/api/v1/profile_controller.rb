class Api::V1::ProfileController < Api::V1::ApiController
  # GET /api/v1/profile
  def show
    json_renderer(current_user, :ok, Api::V1::ProfileSerializer)
  end

  # PUT/PATCH /api/v1/profile
  def update
    current_user.update!(profile_params)
    head :no_content
  end

  private

  def profile_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
