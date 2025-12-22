require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is invalid without a role' do
      user = build(:user, role: nil)
      expect(user).not_to be_valid
    end
  end

  describe 'roles' do
    it 'defaults to student' do
      user = User.new
      expect(user.role).to eq('student')
    end

    it 'can be an admin' do
      user = build(:user, :admin)
      expect(user.admin?).to be true
    end

    it 'can be a school_admin' do
      user = build(:user, :school_admin)
      expect(user.school_admin?).to be true
    end
  end
end
