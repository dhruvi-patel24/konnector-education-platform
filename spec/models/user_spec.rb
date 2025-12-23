require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:role) }
  end

  describe "associations" do
    it { should belong_to(:school).optional }
    it { should have_many(:enrollments) }
    it { should have_many(:batches).through(:enrollments) }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(admin: 0, school_admin: 1, student: 2) }
  end

  describe "default role" do
    it "sets role to student for new records" do
      user = User.new(email: 'test@example.com', password: 'password123')
      expect(user.role).to eq('student')
    end

    it "does not override explicitly set role" do
      user = User.new(email: 'test@example.com', password: 'password123', role: :admin)
      expect(user.role).to eq('admin')
    end
  end

  describe "devise modules" do
    it "includes database_authenticatable" do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it "includes registerable" do
      expect(User.devise_modules).to include(:registerable)
    end

    it "includes rememberable" do
      expect(User.devise_modules).to include(:rememberable)
    end

    it "includes validatable" do
      expect(User.devise_modules).to include(:validatable)
    end

    it "does not include recoverable" do
      expect(User.devise_modules).not_to include(:recoverable)
    end
  end

  describe "role methods" do
    let(:admin) { create(:user, :admin) }
    let(:school_admin) { create(:user, :school_admin) }
    let(:student) { create(:user, :student) }

    it "correctly identifies admin role" do
      expect(admin.admin?).to be true
      expect(admin.school_admin?).to be false
      expect(admin.student?).to be false
    end

    it "correctly identifies school_admin role" do
      expect(school_admin.admin?).to be false
      expect(school_admin.school_admin?).to be true
      expect(school_admin.student?).to be false
    end

    it "correctly identifies student role" do
      expect(student.admin?).to be false
      expect(student.school_admin?).to be false
      expect(student.student?).to be true
    end
  end
end
