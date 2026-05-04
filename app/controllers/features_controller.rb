class FeaturesController < ApplicationController
  before_action :require_authentication

  def index
    @features = Feature.includes(:user).order(created_at: :desc)
  end

  def new
    @feature = Feature.new
  end

  def create
    @feature = current_user.features.build(feature_params)

    if @feature.save
      redirect_to features_path, notice: "Feature submitted successfully."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def feature_params
    params.expect(feature: [ :title, :description ])
  end
end
