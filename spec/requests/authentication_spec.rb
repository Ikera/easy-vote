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
          user: attributes_for(:user)
        }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Feature Requests")
      expect(response.body).to include("Welcome,")
    end
  end

  describe "POST /session" do
    let!(:user) { create(:user, password: "password123", password_confirmation: "password123") }

    it "logs in with valid credentials" do
      sign_in_as(user)

      expect(response).to redirect_to(root_path)
    end

    it "rejects invalid credentials" do
      post session_path, params: { email: user.email, password: "bad-password" }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Invalid email or password")
    end
  end

  describe "DELETE /session" do
    let!(:user) { create(:user, password: "password123", password_confirmation: "password123") }

    it "logs out" do
      sign_in_as(user)
      delete session_path

      expect(response).to redirect_to(new_session_path)
    end
  end
end
