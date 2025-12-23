require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "requires a role" do
      user = build(:user)
      user.role = nil
      expect(user).not_to be_valid
    end

    it "requires an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "requires a password" do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end
  end

  describe "associations" do
    it "can belong to a school" do
      school = create(:school)
      user = create(:user, school: school)
      expect(user.school).to eq(school)
    end

    it "can have many enrollments" do
      user = create(:user)
      expect(user).to respond_to(:enrollments)
    end

    it "can have many batches through enrollments" do
      user = create(:user)
      expect(user).to respond_to(:batches)
    end
  end

  describe "enums" do
    it "defines admin role" do
      user = create(:user, role: :admin)
      expect(user.admin?).to be true
    end

    it "defines school_admin role" do
      user = create(:user, role: :school_admin)
      expect(user.school_admin?).to be true
    end

    it "defines student role" do
      user = create(:user, role: :student)
      expect(user.student?).to be true
    end
  end

  describe "default role" do
    it "sets role to student by default" do
      user = User.new(email: 'test@example.com', password: 'password123')
      user.save
      expect(user.role).to eq('student')
    end

    it "does not override explicitly set role" do
      user = User.new(email: 'test@example.com', password: 'password123', role: :admin)
      user.save
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
