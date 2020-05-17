require "rails_helper"

RSpec.describe ApplicationController, type: :request do
  class TestController < ApplicationController
    skip_before_action :authenticate_user!, only: :maybe_user

    def force_user
      render json: { current_user: current_user.username }
    end

    def maybe_user
      render json: { current_user: current_user&.username }
    end

    def parameters
      params.require(:color)
      head :ok
    end

    def not_found
      User.find("potato")
    end
  end

  before :all do
    Rails.application.routes.disable_clear_and_finalize = true
    Rails.application.routes.draw do
      get "test_force_user", to: "test#force_user", as: :test_force_user
      get "test_maybe_user", to: "test#maybe_user", as: :test_maybe_user
      get "test_parameters", to: "test#parameters", as: :test_parameters
      get "test_not_found", to: "test#not_found", as: :test_not_found
    end
  end

  after(:all) do
    Rails.application.routes.disable_clear_and_finalize = false
    Rails.application.reload_routes!
  end

  before { sign_in("bea") }

  describe "default auth" do
    it "sets the current user when signed in" do
      get test_force_user_path
      expect(response).to have_http_status :ok
      expect(response_json).to eq current_user: "bea"
    end

    it "renders 401 Unauthorized when user is not signed in" do
      sign_out

      get test_force_user_path
      expect(response).to have_http_status :unauthorized
      expect(response_json).to eq error: "must be signed in"
    end
  end

  describe "soft auth" do
    it "sets the current user when signed in" do
      get test_maybe_user_path
      expect(response).to have_http_status :ok
      expect(response_json).to eq current_user: "bea"
    end

    it "allows the request when no user is signed in" do
      sign_out

      get test_maybe_user_path
      expect(response).to have_http_status :ok
      expect(response_json).to eq current_user: nil
    end
  end

  it "renders 422 Unprocessable Entity when required param is missing" do
    get test_parameters_path
    expect(response).to have_http_status :unprocessable_entity
    expect(response_json).to eq error: "parameter missing: color"
  end
end
