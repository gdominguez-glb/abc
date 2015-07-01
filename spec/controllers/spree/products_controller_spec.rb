require 'rails_helper'

RSpec.describe Spree::ProductsController, type: :controller do
  routes { Spree::Core::Engine.routes }
  
  describe "POST 'favorite'" do
    login_user

    let(:product) { create(:product, slug: 'hello') }
    
    it "favorite product" do
      post :favorite, id: product.slug, format: :js
      expect(response).to be_success
      expect(controller.current_spree_user.favorite_products.count).to eq(1)
    end
  end
end
