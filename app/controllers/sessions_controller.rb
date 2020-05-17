class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :create, :destroy]

  def show
    render json: { current_user: current_user&.username }
  end

  def create
    params.require(:username)
    params.require(:password)

    session.delete(:user_id)

    user = User.
      find_by(username: params[:username])&.
      authenticate(params[:password])

    if user
      session[:user_id] = user.id
      render json: { current_user: user.username }, status: :created
    else
      sleep SecureRandom.rand(0.05..0.1)
      render status: :unauthorized,
      json: { error: "incorrect username and password" }
    end
  end

  def destroy
    session.delete(:user_id)
    render json: { current_user: nil }
  end
end
