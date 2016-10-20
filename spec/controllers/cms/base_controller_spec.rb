require 'rails_helper'

RSpec.describe Cms::BaseController, type: :controller do
  controller do
    def index
      @current_ability = current_ability
      render text: 'testing'
    end
  end

  describe "#authenticate_cms_accessor!" do
    it "redirect without login" do
      get :index
      expect(response).to be_redirect
    end

    context "as user" do
      login_user

      it "redirect with normal user" do
        get :index
        expect(response).to be_redirect
      end
    end

    context "as vanity url" do
      login_vanity_admin

      it "redirect with vanity admin user" do
        get :index
        expect(response).to be_redirect
      end
    end

    context "as admin" do
      login_admin

      it "success with login" do
        get :index, {}
        expect(response).to be_success
        expect(assigns(:current_ability)).not_to be_nil
      end
    end
  end
end
