class Course < ApplicationRecord
  belongs_to :school
  has_many :batches
end
