require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:school) { create(:school) }
  let(:school_admin) { create(:user, :school_admin, school: school) }
  let(:student) { create(:user, :student, school: school) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "returns a successful response for school_admins" do
      get :index, params: { role: 'school_admin' }
      expect(response).to be_successful
    end

    it "filters users by role" do
      school_admin
      student
      get :index, params: { role: 'school_admin' }
      expect(assigns(:users)).to include(school_admin)
      expect(assigns(:users)).not_to include(student)
    end

    it "defaults to school_admin role if no role specified" do
      get :index
      expect(assigns(:role)).to eq('school_admin')
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new, params: { role: 'student' }
      expect(response).to be_successful
    end

    it "initializes a new user with the specified role" do
      get :new, params: { role: 'student' }
      expect(assigns(:user).role).to eq('student')
    end
  end

  describe "POST #create" do
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
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "redirects to the users index with the correct role" do
        post :create, params: valid_params
        expect(response).to redirect_to(admin_users_path(role: 'school_admin'))
      end

      it "sets a success notice" do
        post :create, params: valid_params
        expect(flash[:notice]).to match(/successfully created/)
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
          post :create, params: invalid_params
        }.not_to change(User, :count)
      end

      it "renders the new template" do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: school_admin.id }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:new_email) { 'updated@example.com' }

      it "updates the user" do
        patch :update, params: { id: school_admin.id, user: { email: new_email } }
        school_admin.reload
        expect(school_admin.email).to eq(new_email)
      end

      it "redirects to the users index" do
        patch :update, params: { id: school_admin.id, user: { email: new_email } }
        expect(response).to redirect_to(admin_users_path(role: school_admin.role))
      end
    end

    context "with invalid parameters" do
      it "does not update the user" do
        original_email = school_admin.email
        patch :update, params: { id: school_admin.id, user: { email: '' } }
        school_admin.reload
        expect(school_admin.email).to eq(original_email)
      end

      it "renders the edit template" do
        patch :update, params: { id: school_admin.id, user: { email: '' } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the user" do
      user_to_delete = create(:user, :student, school: school)
      expect {
        delete :destroy, params: { id: user_to_delete.id }
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users index with the correct role" do
      delete :destroy, params: { id: school_admin.id }
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
        get :index
        expect(response).to redirect_to(root_path)
      end

      it "sets an alert message" do
        get :index
        expect(flash[:alert]).to eq('Access denied.')
      end
    end
  end
end
