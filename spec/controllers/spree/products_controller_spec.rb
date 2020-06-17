require 'rails_helper'

RSpec.describe Spree::ProductsController, type: :controller do
  include Spree::TestingSupport::ControllerRequests

  let!(:user) { create(:gm_user) }
  let!(:product) do
    create(:product, name: 'Product A',
                     for_sale: true,
                     available_on: 2.days.ago,
                     fulfillment_date: 2.days.ago,
                     access_url: 'http://google.com/download_page/1',
                     license_text: 'License')
  end

  let!(:inkling_product) do
    create(:product, name: 'Product B',
                     for_sale: true,
                     available_on: 2.days.ago,
                     fulfillment_date: 2.days.ago,
                     product_type: 'inkling')
  end

  let!(:get_in_touch_product) do
    create(:product, name: 'Product C',
                     for_sale: true,
                     available_on: 2.days.ago,
                     fulfillment_date: 2.days.ago,
                     product_type: 'get_in_touch',
                     get_in_touch_url: 'http://fake.com')
  end

  let!(:archived_product) do
    create(:product, name: 'Product D',
                     for_sale: true,
                     archived: true,
                     available_on: 2.days.ago,
                     fulfillment_date: 2.days.ago,
                     access_url: 'http://google.com/download_page/1',
                     license_text: 'License')
  end

  let!(:group_product) do
    create(:product, name: 'Product E',
                     for_sale: true,
                     available_on: 2.days.ago,
                     fulfillment_date: 2.days.ago,
                     product_type: 'group',
                     access_url: 'http://google.com/download_page/1',
                     license_text: 'License')
  end

  let!(:licensed_product_a) do
    create(:spree_licensed_product, product: product,
                                    user: user,
                                    quantity: 1,
                                    can_be_distributed: false)
  end

  let!(:licensed_product_b) do
    create(:spree_licensed_product, product: inkling_product,
                                    user: user,
                                    quantity: 1,
                                    can_be_distributed: false)
  end

  let!(:licensed_product_d) do
    create(:spree_licensed_product, product: archived_product,
                                    user: user,
                                    quantity: 1,
                                    can_be_distributed: false)
  end

  let!(:licensed_product_e) do
    create(:spree_licensed_product, product: group_product,
                                    user: user,
                                    quantity: 1,
                                    can_be_distributed: false)
  end

  let(:product_agreement) do
    create(:spree_product_agreement, product: product, user: user)
  end

  let(:inkling_product_agreement) do
    create(:spree_product_agreement, product: inkling_product, user: user)
  end

  let(:inkling_code) { create(:spree_inkling_code, product: product) }

  before(:each) do
    sign_in :spree_user, user
  end

  describe 'GET index' do
    it 'be success' do
      spree_get :index

      expect(response).to be_success
      expect(assigns(:products)).not_to be_nil
    end
  end

  describe 'GET launch' do
    it 'redirect to terms if have agree to license' do
      get :launch, id: product.slug

      expect(response).to redirect_to(terms_product_path(product))
    end

    it 'redirect to access url if agree to license' do
      product_agreement
      get :launch, id: product.slug

      expect(response).to redirect_to("http://google.com/download_page/1?opened_product_id=#{product.id}")
    end

    it 'redirect to inkling page for inlinking product' do
      inkling_product_agreement
      get :launch, id: inkling_product.slug

      expect(response).to be_redirect
    end
  end

  describe 'POST agree_terms' do
    before(:each) do
      get :agree_terms, id: product.slug
    end

    it 'agree to product license' do
      expect(Spree::ProductAgreement.where(product: product, user: user).exists?).to eq(true)
    end

    it 'redirect to product launch' do
      expect(response).to redirect_to(launch_product_path(product))
    end
  end

  describe 'GET group' do
    it 'show group items of product' do
      get :group, id: product.slug

      expect(response).to be_success
      expect(assigns(:product_group)).to eq(product)
      expect(assigns(:products)).not_to be_nil
    end

    it 'redirect to not found path' do
      get :group, id: '12357683'

      expect(response).to redirect_to('/resources/orders/populate?action=not_found&controller=pages')
    end
  end

  describe 'GET show' do
    it 'should display a product' do
      get :show, id: product.id
      expect(response).to be_success
      expect(assigns(:product)).not_to be_nil
      expect(response).to render_template(:show)
    end

    it 'should redirect if the product was archived' do
      get :show, id: archived_product.id

      expect(response).to redirect_to('/not-found')
    end

    it 'should redirect if the product was in a group' do
      get :show, id: group_product.id

      expect(response).to redirect_to('/resources/products/group/product-e')
    end
  end
end
