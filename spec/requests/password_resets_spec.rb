require "rails_helper"

RSpec.describe "Password resets", type: :request do
  include ActiveJob::TestHelper

  let!(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  before do
    clear_enqueued_jobs
    clear_performed_jobs
    ActionMailer::Base.deliveries.clear
  end

  describe "POST /password_reset" do
    it "always returns a generic message for existing emails" do
      post password_reset_path, params: { email: user.email }

      expect(response).to redirect_to(new_session_path)
      follow_redirect!
      expect(response.body).to include("If your email exists in our system")
    end

    it "always returns a generic message for unknown emails" do
      post password_reset_path, params: { email: "unknown@example.com" }

      expect(response).to redirect_to(new_session_path)
      follow_redirect!
      expect(response.body).to include("If your email exists in our system")
    end

    it "enqueues a reset email for known users" do
      expect {
        post password_reset_path, params: { email: user.email }
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end
  end

  describe "PATCH /passwords/:token" do
    it "updates password with a valid token" do
      token = user.password_reset_token

      patch password_path(token), params: {
        user: {
          password: "newpassword123",
          password_confirmation: "newpassword123"
        }
      }

      expect(response).to redirect_to(root_path)
      expect(user.reload.authenticate("newpassword123")).to be_truthy
    end

    it "rejects invalid token" do
      patch password_path("invalid-token"), params: {
        user: {
          password: "newpassword123",
          password_confirmation: "newpassword123"
        }
      }

      expect(response).to redirect_to(new_password_reset_path)
    end
  end
end
