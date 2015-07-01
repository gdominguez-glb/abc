require 'rails_helper'

RSpec.describe Cms::BaseController, type: :controller do
  controller do
    def index
      @current_ability = current_ability
      render text: 'testing'
    end
  end

  describe "#authenticate_cms_accessor!" do
    let(:user) { create(:gm_user) }
    let(:admin) { user = create(:gm_user); user.spree_roles << Spree::Role.admin; user }

    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:spree_user]
    end

    it "redirect without login" do
      get :index
      expect(response).to be_redirect
    end

    it "redirect with normal user" do
      sign_in :spree_user, user
      get :index
      expect(response).to be_redirect
    end

    it "success with login" do
      sign_in :spree_user, admin
      get :index, {}
      expect(response).to be_success
      expect(assigns(:current_ability)).not_to be_nil
    end
  end
end
