require "rails_helper"

RSpec.describe User, type: :model do
  it "normalizes email" do
    user = create(:user, email: "  ALEX@Example.COM ")

    expect(user.email).to eq("alex@example.com")
  end

  it "requires minimum password length" do
    user = build(:user, password: "short", password_confirmation: "short")

    expect(user).not_to be_valid
    expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
  end
end
