require 'rails_helper'

RSpec.describe Admin::SchoolsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:school_admin) { create(:user, :school_admin) }
  let(:school) { create(:school) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns all schools visible to the user" do
      school1 = create(:school)
      school2 = create(:school)
      get :index
      expect(assigns(:schools)).to match_array([ school1, school2 ])
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new school" do
      get :new
      expect(assigns(:school)).to be_a_new(School)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        { school: { name: 'New School', address: '123 Main St' } }
      end

      it "creates a new school" do
        expect {
          post :create, params: valid_params
        }.to change(School, :count).by(1)
      end

      it "redirects to schools index" do
        post :create, params: valid_params
        expect(response).to redirect_to(admin_schools_path)
      end

      it "sets a success notice" do
        post :create, params: valid_params
        expect(flash[:notice]).to match(/successfully created/)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { school: { name: '', address: '123 Main St' } }
      end

      it "does not create a new school" do
        expect {
          post :create, params: invalid_params
        }.not_to change(School, :count)
      end

      it "renders the new template" do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: school.id }
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: school.id }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:new_name) { 'Updated School Name' }

      it "updates the school" do
        patch :update, params: { id: school.id, school: { name: new_name } }
        school.reload
        expect(school.name).to eq(new_name)
      end

      it "redirects to schools index" do
        patch :update, params: { id: school.id, school: { name: new_name } }
        expect(response).to redirect_to(admin_schools_path)
      end
    end

    context "with invalid parameters" do
      it "does not update the school" do
        original_name = school.name
        patch :update, params: { id: school.id, school: { name: '' } }
        school.reload
        expect(school.name).to eq(original_name)
      end

      it "renders the edit template" do
        patch :update, params: { id: school.id, school: { name: '' } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the school" do
      school_to_delete = create(:school)
      expect {
        delete :destroy, params: { id: school_to_delete.id }
      }.to change(School, :count).by(-1)
    end

    it "redirects to schools index" do
      delete :destroy, params: { id: school.id }
      expect(response).to redirect_to(admin_schools_path)
    end
  end

  describe "authorization" do
    context "when user is not authenticated" do
      before do
        sign_out admin
      end

      it "redirects to root path" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
