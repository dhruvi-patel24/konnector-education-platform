require 'rails_helper'

RSpec.describe "Admin::Schools", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:school_admin) { create(:user, :school_admin) }
  let(:school) { create(:school) }

  before do
    sign_in admin
  end

  describe "GET /admin/schools" do
    it "returns a successful response" do
      get admin_schools_path
      expect(response).to be_successful
    end

    it "displays all schools" do
      school1 = create(:school, name: "Test School 1")
      school2 = create(:school, name: "Test School 2")
      get admin_schools_path
      expect(response.body).to include("Test School 1")
      expect(response.body).to include("Test School 2")
    end
  end

  describe "GET /admin/schools/new" do
    it "returns a successful response" do
      get new_admin_school_path
      expect(response).to be_successful
    end
  end

  describe "POST /admin/schools" do
    context "with valid parameters" do
      let(:valid_params) do
        { school: { name: 'New School', address: '123 Main St' } }
      end

      it "creates a new school" do
        expect {
          post admin_schools_path, params: valid_params
        }.to change(School, :count).by(1)
      end

      it "redirects to schools index" do
        post admin_schools_path, params: valid_params
        expect(response).to redirect_to(admin_schools_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { school: { name: '', address: '123 Main St' } }
      end

      it "does not create a new school" do
        expect {
          post admin_schools_path, params: invalid_params
        }.not_to change(School, :count)
      end
    end
  end

  describe "GET /admin/schools/:id" do
    it "returns a successful response" do
      get admin_school_path(school)
      expect(response).to be_successful
    end
  end

  describe "GET /admin/schools/:id/edit" do
    it "returns a successful response" do
      get edit_admin_school_path(school)
      expect(response).to be_successful
    end
  end

  describe "PATCH /admin/schools/:id" do
    context "with valid parameters" do
      let(:new_name) { 'Updated School Name' }

      it "updates the school" do
        patch admin_school_path(school), params: { school: { name: new_name } }
        school.reload
        expect(school.name).to eq(new_name)
      end

      it "redirects to schools index" do
        patch admin_school_path(school), params: { school: { name: new_name } }
        expect(response).to redirect_to(admin_schools_path)
      end
    end
  end

  describe "DELETE /admin/schools/:id" do
    it "destroys the school" do
      school_to_delete = create(:school)
      expect {
        delete admin_school_path(school_to_delete)
      }.to change(School, :count).by(-1)
    end

    it "redirects to schools index" do
      delete admin_school_path(school)
      expect(response).to redirect_to(admin_schools_path)
    end
  end

  describe "authorization" do
    context "when user is not authenticated" do
      before do
        sign_out admin
      end

      it "redirects to sign in page" do
        get admin_schools_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
