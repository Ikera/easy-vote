FactoryBot.define do
  factory :feature do
    association :user
    sequence(:title) { |n| "Feature #{n}" }
    description { "A clear description of the requested feature for prioritization." }
  end
end
