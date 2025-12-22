require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "displays the welcome message" do
      get root_path
      expect(response.body).to include("Welcome to Konnector")
    end

    context "when not signed in" do
      it "shows the login form" do
        get root_path
        expect(response.body).to include("Log in")
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it "does not show the login form" do
        get root_path
        expect(response.body).not_to include("Log in")
      end

      it "shows the logout button" do
        get root_path
        expect(response.body).to include("Logout")
      end
    end
  end
end
