require 'rails_helper'

RSpec.describe Spree::Admin::UsersController, type: :controller do
  routes { Spree::Core::Engine.routes }
  let!(:product) { create(:product) }
  let!(:user) { create(:gm_user) }
  login_admin

  describe "GET 'products'" do

    it "get user product" do
      get :products, id: user.id
      expect(response).to be_success
      expect(assigns(:products)).not_to be_nil
    end
  end

  describe "GET 'licenses'" do
    let!(:licensed_product) { create(:spree_licensed_product, product: product, user: user) }

    it "return licenses of user" do
      get :licenses, id: user.id

      expect(response).to be_success
      expect(assigns(:licensed_products).to eq([licensed_product])
    end
  end
end
