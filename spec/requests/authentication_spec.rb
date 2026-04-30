require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "GET /" do
    it "redirects guests to login" do
      get root_path

      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "POST /users" do
    it "creates account and starts session" do
      expect {
        post users_path, params: {
          user: {
            name: "Ivica",
            email: "ivica@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("You are signed in as")
    end
  end

  describe "POST /session" do
    let!(:user) { User.create!(name: "Test", email: "test@example.com", password: "password123", password_confirmation: "password123") }

    it "logs in with valid credentials" do
      post session_path, params: { email: user.email, password: "password123" }

      expect(response).to redirect_to(root_path)
    end

    it "rejects invalid credentials" do
      post session_path, params: { email: user.email, password: "bad-password" }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Invalid email or password")
    end
  end

  describe "DELETE /session" do
    let!(:user) { User.create!(name: "Test", email: "test@example.com", password: "password123", password_confirmation: "password123") }

    it "logs out" do
      post session_path, params: { email: user.email, password: "password123" }
      delete session_path

      expect(response).to redirect_to(new_session_path)
    end
  end
end
