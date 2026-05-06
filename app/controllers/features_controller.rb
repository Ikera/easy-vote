class FeaturesController < ApplicationController
  PER_PAGE = 5

  before_action :require_authentication

  def index
    page = [ params.fetch(:page, 1).to_i, 1 ].max
    @features, @next_page = paginated_features(page)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @feature = Feature.new
  end

  def create
    @feature = current_user.features.build(feature_params)

    if @feature.save
      flash.now[:notice] = "Feature submitted successfully."
      respond_to do |format|
        format.turbo_stream { render :create }
        format.html { redirect_to features_path, notice: "Feature submitted successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create_failure, status: :unprocessable_content }
        format.html { render :new, status: :unprocessable_content }
      end
    end
  end

  private

  def paginated_features(page)
    scoped_features = Feature.includes(:user).order(created_at: :desc)
    offset = (page - 1) * PER_PAGE
    chunk = scoped_features.offset(offset).limit(PER_PAGE + 1).to_a

    next_page = page + 1 if chunk.length > PER_PAGE
    features = chunk.first(PER_PAGE)

    [ features, next_page ]
  end

  def feature_params
    params.expect(feature: [ :title, :description ])
  end
end
