require "system_helper"

RSpec.feature "Welcome Homepage", type: :system do
  scenario "User lands on homepage" do
    visit "/"
    expect(page).to have_text "Welcome!"
  end
end
