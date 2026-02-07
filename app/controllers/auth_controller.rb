class AuthController < ApplicationController
  def login
    user = User.find_by(email: params[:email].to_s.downcase)

    if user&.authenticate(params[:password])
      user.rotate_token!
      render json: { token: user.auth_token }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def logout
    authenticate!
    return if performed?

    current_user.rotate_token!
    render json: { message: "Logged out" }, status: :ok
  end
end
