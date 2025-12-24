class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :batch

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :user_id, uniqueness: { scope: :batch_id, message: "is already enrolled in this batch" }
end
