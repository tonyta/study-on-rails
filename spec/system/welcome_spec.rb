require "system_helper"

RSpec.feature "Welcome Homepage", type: :system do
  before { User.create!(username: "amy", password: "test-password") }

  scenario "unauthenticated user lands on homepage and signs in" do
    visit "/"
    expect(page).to have_text "Please, sign in..."

    fill_in "username", with: "amy"
    fill_in "password", with: "test-password"
    click_button "sign in"

    expect(page).to have_text "Welcome, amy!"
  end

  scenario "already authenticated user lands on homepage and signs out" do
    sign_in("amy")
    visit "/"
    expect(page).to have_text "Welcome, amy!"

    click_button "sign out"
    expect(page).to have_text "Please, sign in..."
  end
end
