require "rails_helper"

RSpec.describe "Features modal", type: :system do
  before do
    if ENV["JS_SYSTEM_TESTS"] == "1"
      driven_by(:selenium, using: :headless_chrome, screen_size: [1400, 1400])
    else
      driven_by(:rack_test)
    end
  end

  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  it "opens modal, shows validation errors, and creates feature" do
    visit new_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    expect(page).to have_content("Feature Requests")

    click_link "New feature"
    expect(page).to have_content("Submit a feature")

    click_button "Submit feature"
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")

    fill_in "Title", with: "Add keyboard shortcuts"
    fill_in "Description", with: "Allow keyboard shortcuts for common actions in the voting UI."
    click_button "Submit feature"

    expect(page).to have_content("Feature submitted successfully.")
    expect(page).to have_content("Add keyboard shortcuts")
    expect(page).to have_content("Allow keyboard shortcuts for common actions in the voting UI.")
    expect(page).not_to have_css("turbo-frame#modal section")
  end
end
