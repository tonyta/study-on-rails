require "rails_helper"

RSpec.describe SessionsController, type: :request do
  before { User.create!(username: "amy", password: "password") }

  describe "#show" do
    specify "returns no session if no user is signed in" do
      get session_path
      expect(response).to have_http_status :ok
      expect(response_json).to eq current_user: nil
    end
  end

  describe "#create" do
    specify "signing in an existing user will set the session" do
      post session_path, params: { username: "amy", password: "password" }
      expect(response).to have_http_status :created
      expect(response_json).to eq current_user: "amy"

      get session_path
      expect(response).to have_http_status :ok
      expect(response_json).to eq current_user: "amy"
    end

    describe "signin failure cases" do
      specify "signin fails with blank username or password" do
        post session_path
        expect(response).to have_http_status :unprocessable_entity

        post session_path, params: { username: "amy" }
        expect(response).to have_http_status :unprocessable_entity

        post session_path, params: { username: "password" }
        expect(response).to have_http_status :unprocessable_entity
      end

      specify "signin fails with invalid username while preventing timing attacks" do
        post session_path, params: { username: "invalid", password: "password" }
        expect(response).to have_http_status :unauthorized
        expect(Float headers["x-runtime"]).to be > 0.05
      end

      specify "signin fails with invalid password while preventing timing attacks" do
        post session_path, params: { username: "amy", password: "invalid" }
        expect(response).to have_http_status :unauthorized
        expect(Float headers["x-runtime"]).to be > 0.05
      end

      specify "signin failure while already signed in will signout" do
        post session_path, params: { username: "amy", password: "password" }
        expect(response).to have_http_status :created
        expect(response_json).to eq current_user: "amy"

        post session_path, params: { username: "amy", password: "invalid" }
        expect(response).to have_http_status :unauthorized

        get session_path
        expect(response).to have_http_status :ok
        expect(response_json).to eq current_user: nil
      end
    end
  end

  specify "signing out will delete the session" do
    post session_path, params: { username: "amy", password: "password" }
    expect(response).to have_http_status :created
    expect(response_json).to eq current_user: "amy"

    delete session_path
    expect(response).to have_http_status :ok
    expect(response_json).to eq current_user: nil

    get session_path
    expect(response).to have_http_status :ok
    expect(response_json).to eq current_user: nil
  end

  specify "signing out works when not signed in" do
    get session_path
    expect(response).to have_http_status :ok
    expect(response_json).to eq current_user: nil

    delete session_path
    expect(response).to have_http_status :ok
    expect(response_json).to eq current_user: nil
  end
end
