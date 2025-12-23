require 'rails_helper'

RSpec.describe School, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_many(:courses).dependent(:destroy) }
  end

  describe "creation" do
    it "creates a valid school" do
      school = build(:school)
      expect(school).to be_valid
    end

    it "is invalid without a name" do
      school = build(:school, name: nil)
      expect(school).not_to be_valid
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
