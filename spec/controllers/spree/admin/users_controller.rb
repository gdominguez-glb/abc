require 'rails_helper'

RSpec.describe Spree::Admin::UsersController, type: :controller do
  routes { Spree::Core::Engine.routes }

  describe "GET 'products'" do
    let!(:user) { create(:gm_user) }
    login_admin

    it "get user product" do
      get :products, id: user.id
      expect(response).to be_success
      expect(assigns(:products)).not_to be_nil
    end
  end
end
