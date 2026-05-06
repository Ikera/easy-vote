require "rails_helper"

RSpec.describe Feature, type: :model do
  it "is valid with title, description and user" do
    feature = build(:feature)

    expect(feature).to be_valid
  end

  it "requires a description" do
    feature = build(:feature, description: "")

    expect(feature).not_to be_valid
    expect(feature.errors[:description]).to include("can't be blank")
  end
end
