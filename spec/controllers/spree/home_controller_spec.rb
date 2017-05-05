require 'rails_helper'

RSpec.describe Spree::HomeController, type: :controller do
  routes { Spree::Core::Engine.routes }

  describe "GET 'index'" do
    let!(:product) { create(:product, show_in_storefront: true, individual_sale: true, for_sale: true, available_on: 1.days.ago) }
    let!(:store_taxonomy) { create(:taxonomy, show_in_store: true, show_in_video: false) }
    let!(:video_taxonomy) { create(:taxonomy, show_in_store: false, show_in_video: true) }

    before(:each) do
      get :index
    end

    it "set products for sale" do
      expect(assigns(:products)).to eq([product])
    end

    it "set store taxonomies" do
      expect(assigns(:taxonomies)).to eq([store_taxonomy])
    end
  end
end
