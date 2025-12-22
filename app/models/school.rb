class School < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :courses, dependent: :destroy

  validates :name, presence: true
end
