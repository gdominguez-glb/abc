require 'rails_helper'

RSpec.describe Spree::OrdersController, type: :controller do
  routes { Spree::Core::Engine.routes }

  describe "POST 'update_simple_cart'" do
    let!(:product) { create(:product) }

    login_user

    it "update cart" do
      patch :update_simple_cart, params: { order:
                                           { line_items_attributes:
                                             { '0' => { quantity: 2, id: product.id }}} },
                                             format: :js
      expect(response).to be_success
    end
  end

  describe "bulk add products to carts" do
    let!(:user) { create(:gm_user) }
    let!(:product_a) { create(:product) }
    let!(:product_b) { create(:product) }

    before do
      allow(controller).to receive_messages(:try_spree_current_user => user)
      get :add_products_to_cart,
      params: { product_ids: [product_a.id, product_b.id] }
    end

    it "add products to carts" do
      order = user.orders.last

      expect(order.line_items.size).to eq(2)
      expect(response).to be_redirect
    end

  end

  describe "Update" do
    let(:order) do
      Spree::Order.create!
    end

    before do
      allow(controller).to receive :check_authorization
      allow(controller).to receive_messages current_order: order
    end

    login_user

    it "should render the edit view (on failure)" do
      # email validation is only after address state
      order.update_column(:state, 'delivery')
      put :update, params: { order: { email: '' } , order_id: order.id }
      expect(response).to render_template :edit
    end

    it "should redirect to cart path (on success)" do
      allow(order).to receive(:update_attributes).and_return true
      put :update, {}, params: { order_id: 1 }
      expect(response).to redirect_to(cart_path)
    end

  end
end
