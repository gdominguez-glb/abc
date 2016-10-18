require 'rails_helper'

RSpec.describe DownloadPagesController, type: :controller do
  let!(:download_page) { create(:download_page, slug: 'abc-download') }

  describe "without login" do
    it "redirect user without login" do
      get :show, slug: 'abc-download'
      expect(response).to redirect_to('/store/login')
    end
  end

  describe "with login" do
    let(:user) { create(:gm_user) }
    let!(:product) { create(:product) }
    let!(:download_product) { create(:download_product, product: product, download_page: download_page) }
    let!(:licensed_product) { create(:spree_licensed_product, user: user, product: product, quantity: 1, can_be_distributed: false) }

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:spree_user]
      sign_in :spree_user, user
    end

    it "success" do
      get :show, slug: 'abc-download'
      expect(response).to be_success
      expect(assigns(:download_page)).to eq(download_page)
      expect(assigns(:products)).to eq([product])
      expect(assigns(:boughted_products)).to eq([product])
    end

    it "redirect to not found if downlaod page not exists" do
      get :show, slug: 'non-exist-download-page'
      expect(response).to redirect_to('/not-found')
    end
  end
end
