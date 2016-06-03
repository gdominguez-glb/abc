require 'rails_helper'

RSpec.describe Spree::ProductsController, type: :controller do
  include Spree::TestingSupport::ControllerRequests

  let!(:user) { create(:gm_user) }
  let!(:product) { create(:product, name: 'Product A', for_sale: true, available_on: 2.days.ago, fulfillment_date: 2.days.ago, access_url: 'http://google.com/download_page/1', license_text: 'License') }
  let!(:inkling_product) { create(:product, name: 'Product B', for_sale: true, available_on: 2.days.ago, fulfillment_date: 2.days.ago, product_type: 'inkling') }
  let!(:get_in_touch_product) { create(:product, name: 'Product C', for_sale: true, available_on: 2.days.ago, fulfillment_date: 2.days.ago, product_type: 'get_in_touch', get_in_touch_url: "http://fake.com") }
  let!(:licensed_product_a) { create(:spree_licensed_product, product: product, user: user, quantity: 1, can_be_distributed: false) }
  let!(:licensed_product_b) { create(:spree_licensed_product, product: inkling_product, user: user, quantity: 1, can_be_distributed: false) }
  let(:product_agreement) { create(:spree_product_agreement, product: product, user: user) }
  let(:inkling_product_agreement) { create(:spree_product_agreement, product: inkling_product, user: user) }
  let(:inkling_code) { create(:spree_inkling_code, product: product) }

  before(:each) do
    sign_in :spree_user, user
  end

  describe "GET index" do
    it "be success" do
      spree_get :index

      expect(response).to be_success
      expect(assigns(:products)).not_to be_nil
    end
  end

  describe "GET launch" do
    it "redirect to terms if have agree to license" do
      get :launch, id: product.slug

      expect(response).to redirect_to(terms_product_path(product))
    end

    it "redirect to access url if agree to license" do
      product_agreement
      get :launch, id: product.slug

      expect(response).to redirect_to("http://google.com/download_page/1?opened_product_id=#{product.id}")
    end

    it "redirect to inkling page for inlinking product" do
      inkling_product_agreement
      get :launch, id: inkling_product.slug

      expect(response).to be_redirect
    end
  end

  describe "POST agree_terms" do
    before(:each) do
      get :agree_terms, id: product.slug
    end

    it "agree to product license" do
      expect(Spree::ProductAgreement.where(product: product, user: user).exists?).to eq(true)
    end

    it "redirect to product launch" do
      expect(response).to redirect_to(launch_product_path(product))
    end
  end

  describe "GET group" do
    it 'show group items of product' do
      get :group, id: product.slug

      expect(response).to be_success
      expect(assigns(:product_group)).to eq(product)
      expect(assigns(:products)).not_to be_nil
    end
  end

  describe "GET 'show'" do

    it "should redirect to get_in_touch_url, get_in_touch type products" do
      get :show, id: get_in_touch_product.id
      expect(assigns(:product)).not_to be_nil
      expect(response).to redirect_to(get_in_touch_product.get_in_touch_url)
    end

    it "should display a product" do
      get :show, id: product.id
      expect(response).to be_success
      expect(assigns(:product)).not_to be_nil
      expect(response).to render_template(:show)
    end
  end
end
