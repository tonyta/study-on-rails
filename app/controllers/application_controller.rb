class ApplicationController < ActionController::Base
  before_action :authenticate_user
  before_action :authenticate_user!

  rescue_from ActionController::ParameterMissing do |error|
    render status: :unprocessable_entity,
      json: { error: "parameter missing: #{error.param}" }
  end

  private

  attr_reader :current_user

  def authenticate_user
    return @current_user if defined? @current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    return if authenticate_user
    render status: :unauthorized, json: { error: "must be signed in" }
  end
end
