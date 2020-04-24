require 'rails_helper'

RSpec.describe Spree::Admin::ProductsController, type: :controller do
  routes { Spree::Core::Engine.routes }
  login_admin
  let!(:product) do
    create(
      :product,
      name: 'Product A',
      for_sale: true,
      available_on: 2.days.ago,
      fulfillment_date: 2.days.ago
    )
  end

  let!(:group_product) do
    create(
      :product,
      name: 'Product A',
      for_sale: true,
      available_on: 2.days.ago,
      fulfillment_date: 2.days.ago,
      product_type: 'group'
    )
  end

  describe 'GET index' do
    it 'should pass' do
      get :index
      expect(assigns(:collection)).not_to be_nil
      expect(response).to be_success
    end
  end

  describe 'POST archive' do
    it 'should archive a product' do
      post :archive, id: product.slug
      expect(response).to redirect_to(admin_product_path(product))
      expect(product.reload.archived).to be_truthy
      expect(controller).to set_flash[:notice].to('Successfully archive product')
    end
  end

  describe 'POST unarchive' do
    it 'should unarchive a product' do
      post :unarchive, id: product.slug
      expect(response).to redirect_to(admin_product_path(product))
      expect(product.reload.archived).to be_falsey
      expect(controller).to set_flash[:notice].to('Successfully un-archive product')
    end
  end

  describe 'GET preview' do
    it 'should preview a group type product' do
      get :preview, id: group_product.slug
      expect(response).to have_http_status(:ok)
    end

    it 'should preview a product' do
      get :preview, id: product.slug
      expect(response).to have_http_status(:ok)
    end
  end
end
