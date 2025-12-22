class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { admin: 0, school_admin: 1, student: 2 }

  belongs_to :school, optional: true
  has_many :enrollments
  has_many :batches, through: :enrollments

  validates :role, presence: true
end
