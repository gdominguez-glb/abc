require 'rails_helper'

RSpec.describe TermsOfServiceController, type: :controller do

  describe "GET 'display'" do
    it "success" do
      get :display
      expect(response).to be_success
    end
  end

  describe "POST 'accept'" do
    let(:user) { create(:gm_user) }
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:spree_user]
      sign_in :spree_user, user
    end

    it "accept terms" do
      post :accept
      expect(response).to redirect_to('/account/products')
      expect(user.reload.accepted_terms?).to eq(true)
    end
  end
end
