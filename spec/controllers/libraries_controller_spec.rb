require 'rails_helper'

RSpec.describe LibrariesController, type: :controller do
  let(:product) { create(:product, slug: 'library-product') }

  describe "without login" do
    it "redirect without login" do
      get :show, params: {id: product.slug}
      expect(response).to redirect_to('/store/login')
    end
  end

  describe "with login" do
    let(:user) { create(:gm_user) }
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:spree_user]
      sign_in :spree_user, user
    end

    describe "without access" do
      it "redirect without access" do
        get :show, params: {id: product.slug}
        expect(response).to redirect_to('/')
      end
    end

    describe "with access" do
      it "show product library" do
        create(:spree_licensed_product, user: user, product: product, quantity: 1, can_be_distributed: false)
        get :show, params: {id: product.slug}
        expect(response).to be_success
        expect(assigns(:product)).to eq(product)
        expect(assigns(:library_leafs)).not_to be_nil
      end
    end
  end
end
