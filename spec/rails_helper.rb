require "spec_helper"

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

module JsonResponseHelpers
  def response_json
    if response.is_a?(ActionDispatch::TestResponse)
      JSON.parse(response.body, symbolize_names: true)
    else
      raise "response is not an ActionDispatch::TestResponse"
    end
  rescue JSON::ParserError
    raise "response body is not parsable json"
  end
end

module RequestAuthHelpers
  attr_reader :signed_in_user

  def sign_in(user)
    user = User.find_or_create_by!(username: user) if user.is_a?(String)
    user.update!(password: "test-password")

    post session_path, params: { username: user.username, password: "test-password" }
    @integration_session.instance_variable_set(:@response, nil)
    @signed_in_user = user
  end

  def sign_out
    delete session_path
    @integration_session.instance_variable_set(:@response, nil)
    @signed_in_user = nil
  end
end

RSpec.configure do |config|
  config.include JsonResponseHelpers, type: :request
  config.include RequestAuthHelpers, type: :request

  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
end
