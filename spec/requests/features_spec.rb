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

    it "renders five features per page" do
      sign_in_as(user)
      create_list(:feature, 7)

      get features_path

      expect(response).to have_http_status(:ok)
      expect(response.body.scan("<article").size).to eq(5)
    end

    it "returns turbo stream for the next feature page" do
      sign_in_as(user)
      create_list(:feature, 11)

      get features_path(page: 2, format: :turbo_stream)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("action=\"append\" target=\"features\"")
      expect(response.body).to include("action=\"replace\" target=\"features_pagination\"")
    end
  end

  describe "GET /features/new" do
    it "renders form inside turbo frame" do
      sign_in_as(user)

      get new_feature_path, headers: { "Turbo-Frame" => "modal" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("id=\"modal\"")
      expect(response.body).to include("<turbo-frame")
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

    it "returns turbo stream when requested" do
      sign_in_as(user)

      post features_path,
           params: {
             feature: {
               title: "Dark mode toggle",
               description: "Add a persisted dark mode toggle to improve readability at night."
             }
           },
           headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("turbo-stream")
    end

    it "returns frame errors for invalid turbo submit" do
      sign_in_as(user)

      post features_path,
           params: { feature: { title: "", description: "" } },
           headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("modal")
      expect(response.body).to include("Title can")
      expect(response.body).to include("Description can")
      expect(response.body).to include("Description is too short")
    end
  end
end
