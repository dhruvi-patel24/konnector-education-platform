require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:school) { create(:school) }
  let(:school_admin) { create(:user, :school_admin, school: school) }
  let(:student) { create(:user, :student, school: school) }

  before do
    sign_in admin
  end

  describe "GET /admin/users" do
    it "returns a successful response for school_admins" do
      get admin_users_path(role: 'school_admin')
      expect(response).to be_successful
    end

    it "filters users by role" do
      school_admin
      student
      get admin_users_path(role: 'school_admin')
      expect(response.body).to include(school_admin.email)
      expect(response.body).not_to include(student.email)
    end
  end

  describe "GET /admin/users/new" do
    it "returns a successful response" do
      get new_admin_user_path(role: 'student')
      expect(response).to be_successful
    end
  end

  describe "POST /admin/users" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            role: 'school_admin',
            school_id: school.id
          }
        }
      end

      it "creates a new user" do
        expect {
          post admin_users_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "redirects to the users index with the correct role" do
        post admin_users_path, params: valid_params
        expect(response).to redirect_to(admin_users_path(role: 'school_admin'))
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            email: '',
            password: 'password123',
            role: 'student'
          }
        }
      end

      it "does not create a new user" do
        expect {
          post admin_users_path, params: invalid_params
        }.not_to change(User, :count)
      end
    end
  end

  describe "GET /admin/users/:id/edit" do
    it "returns a successful response" do
      get edit_admin_user_path(school_admin)
      expect(response).to be_successful
    end
  end

  describe "PATCH /admin/users/:id" do
    context "with valid parameters" do
      let(:new_email) { 'updated@example.com' }

      it "updates the user" do
        patch admin_user_path(school_admin), params: { user: { email: new_email } }
        school_admin.reload
        expect(school_admin.email).to eq(new_email)
      end

      it "redirects to the users index" do
        patch admin_user_path(school_admin), params: { user: { email: new_email } }
        expect(response).to redirect_to(admin_users_path(role: school_admin.role))
      end
    end
  end

  describe "DELETE /admin/users/:id" do
    it "destroys the user" do
      user_to_delete = create(:user, :student, school: school)
      expect {
        delete admin_user_path(user_to_delete)
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users index with the correct role" do
      delete admin_user_path(school_admin)
      expect(response).to redirect_to(admin_users_path(role: 'school_admin'))
    end
  end

  describe "authorization" do
    context "when user is not an admin" do
      before do
        sign_out admin
        sign_in school_admin
      end

      it "redirects to root path" do
        get admin_users_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
