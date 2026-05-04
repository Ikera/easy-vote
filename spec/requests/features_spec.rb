require "rails_helper"

RSpec.describe "Features", type: :request do
  let(:user) { create(:user) }

  describe "GET /features" do
    it "redirects guests to login" do
      get features_path

      expect(response).to redirect_to(new_session_path)
    end

    it "renders index for logged in users" do
      sign_in_as(user)

      get features_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Feature Requests")
    end
  end

  describe "POST /features" do
    it "creates feature for current user" do
      sign_in_as(user)

      expect {
        post features_path, params: {
          feature: {
            title: "Add webhook support",
            description: "Allow external services to notify this app using signed webhooks."
          }
        }
      }.to change(Feature, :count).by(1)

      expect(Feature.last.user_id).to eq(user.id)
      expect(response).to redirect_to(features_path)
    end
  end
end
