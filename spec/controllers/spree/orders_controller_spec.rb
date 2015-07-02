require 'rails_helper'

RSpec.describe Spree::OrdersController, type: :controller do
  routes { Spree::Core::Engine.routes }

  describe "POST 'update_simple_cart'" do
    let!(:product) { create(:product) }

    login_user

    it "update cart" do
      patch :update_simple_cart, order: { line_items_attributes: { "0" => { quantity: 2, id: product.id }}}, format: :js
      expect(response).to be_success
    end
  end
end
