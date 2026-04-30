require "rails_helper"

RSpec.describe User, type: :model do
  it "normalizes email" do
    user = User.create!(
      name: "Ivica",
      email: "  IVICA@Example.COM ",
      password: "password123",
      password_confirmation: "password123"
    )

    expect(user.email).to eq("ivica@example.com")
  end

  it "requires minimum password length" do
    user = User.new(name: "Ivica", email: "ivica@example.com", password: "short", password_confirmation: "short")

    expect(user).not_to be_valid
    expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
  end
end
