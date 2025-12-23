require 'rails_helper'

RSpec.describe School, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      school = build(:school)
      expect(school).to be_valid
    end

    it "requires a name" do
      school = build(:school, name: nil)
      expect(school).not_to be_valid
    end
  end

  describe "associations" do
    it "can have many users" do
      school = create(:school)
      expect(school).to respond_to(:users)
    end

    it "can have many courses" do
      school = create(:school)
      expect(school).to respond_to(:courses)
    end
  end

  describe "dependent destroy" do
    let(:school) { create(:school) }

    it "destroys associated users when school is destroyed" do
      create(:user, :school_admin, school: school)
      expect {
        school.destroy
      }.to change(User, :count).by(-1)
    end

    it "destroys associated courses when school is destroyed" do
      create(:course, school: school)
      expect {
        school.destroy
      }.to change(Course, :count).by(-1)
    end
  end
end
