class ApplicationController < ActionController::API
  private

  def authenticate!
    token = request.authorization.to_s.sub(/^Bearer\s+/i, "")
    @current_user = User.find_by(auth_token: token)
    return if @current_user

    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
