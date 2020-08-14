# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account::ProductsController, type: :controller do
  let!(:user) { create(:gm_user) }

  before(:each) do
    @first_user = create :gm_user, email: 'example1@example.com'
    @first_user.spree_roles << Spree::Role.find_or_create_by(name: 'school admin')
    @first_user.save

    @product = create :product, product_type: 'inkling'

    licensed_product = create :spree_licensed_product,
                              user: @first_user,
                              product: @product,
                              quantity: 10

    @second_user = create :gm_user, email: 'example2@example.com',
                                    first_name: 'Bruce',
                                    last_name: 'Wayne'

    create :spree_product_distribution,
           licensed_product: licensed_product,
           product: @product,
           from_user: @first_user,
           to_user: @second_user,
           email: @second_user.email,
           quantity: 1

    create :spree_licensed_product,
           user: @second_user,
           product: @product,
           quantity: 1,
           can_be_distributed: false

    sign_in :spree_user, @second_user
  end

  describe 'GET index' do
    it 'be success' do
      create :activity, user: @second_user,
                        action: 'buy',
                        item_type: 'Spree::Product',
                        item_id: @product.id

      create :spree_pinned_product, product_id: @product.id,
                                    user_id: @second_user.id

      create :notification, user_id: @second_user.id

      get :index

      expect(response).to be_success
      expect(assigns(:nav_name)).to eq('My Resources')
      expect(assigns(:my_products)).not_to be_empty
      expect(assigns(:pinned_products)).not_to be_empty
      expect(assigns(:notifications)).not_to be_nil
    end
  end

  describe 'GET launch' do
    it 'redirect to product url' do
      @product = create :product, product_type: 'inkling'

      get :launch, params: { id: @product.id }

      expect(response.headers['Location']).to include('/inkling_codes/product-3')
    end

    it 'redirect to terms url' do
      @product = create :product, product_type: 'inkling', license_text: 'test'

      get :launch, params: { id: @product.id }

      expect(response.headers['Location']).to include('/terms')
    end

    it 'redirect to homepage if the product doesn\'t have a path' do
      @product = create :product
      get :launch, params: { id: @product.id }

      expect(response).to redirect_to('http://test.host/')
    end
  end

  describe 'GET pin_product' do
    it 'be success' do
      get :pin_product, params: { id: @product.id }

      pinned_product = Spree::PinnedProduct.first

      expect(response).to redirect_to('http://test.host/account/products')
      expect(pinned_product.product_id).to eq(@product.id)
    end

    it 'fails if the user pins more than 3 products' do
      @product2 = create :product
      @product3 = create :product

      create :spree_pinned_product, product_id: @product.id,
                                    user_id: @second_user.id
      create :spree_pinned_product, product_id: @product2.id,
                                    user_id: @second_user.id
      create :spree_pinned_product, product_id: @product3.id,
                                    user_id: @second_user.id

      get :pin_product, params: { id: @product.id }

      msg = 'You can not pin more than 3 resources to your dashboard.'

      expect(response).to redirect_to('http://test.host/account/products')
      expect(flash[:notice]).to eq(msg)
    end
  end

  describe 'GET unpin_product' do
    it 'be success' do
      create :spree_pinned_product, product_id: @product.id,
                                    user_id: @second_user.id

      get :unpin_product, params: { id: @product.id }

      pinned_product_count = Spree::PinnedProduct.count

      expect(response).to redirect_to('http://test.host/account/products')
      expect(pinned_product_count).to eq(0)
    end
  end
end
