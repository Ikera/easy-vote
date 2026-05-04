class Feature < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 150 }
  validates :description, presence: true, length: { minimum: 10, maximum: 2000 }
end
