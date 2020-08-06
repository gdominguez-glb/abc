require 'rails_helper'

RSpec.describe Cms::VanityUrlsController, type: :controller do
  let(:vanity_url) { create(:vanity_url) }

  login_vanity_admin

  describe "authentication" do
    context 'user' do
      login_user

      it "redirect for normal user" do
        get :index
        expect(response).to redirect_to('/')
      end
    end

    context "vanity url admin" do
      login_vanity_admin

      it "success for vanity url admin" do
        get :index
        expect(response).to be_success
      end
    end

    context "admin" do
      login_admin

      it "success for admin" do
        get :index
        expect(response).to be_success
      end
    end

  end

  describe "GET 'index'" do
    it "success" do
      get :index
      expect(response).to be_success
      expect(assigns(@vanity_urls)).not_to be_nil
    end
  end

  describe "GET 'new'" do
    it "success" do
      get :new
      expect(response).to be_success
      expect(assigns(@vanity_url)).not_to be_nil
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @vanity_url = double('VanityUrl')
    end

    it "post with valid params" do
      expect(VanityUrl).to receive(:new).and_return(@vanity_url)
      expect(@vanity_url).to receive(:save).and_return(true)
      post :create, params: { vanity_url: { url: '/abc' } }
      expect(response).to redirect_to('/cms/vanity_urls')
    end

    it "post with invalid params" do
      expect(VanityUrl).to receive(:new).and_return(@vanity_url)
      expect(@vanity_url).to receive(:save).and_return(false)
      post :create, params: { vanity_url: { url: '/abc' } }
      expect(response).to render_template(:new)
    end
  end

  describe "GET 'edit'" do
    it "success" do
      get :edit, params: { id: vanity_url.id }
      expect(response).to be_success
      expect(assigns(:vanity_url)).to eq(vanity_url)
    end
  end

  describe "PUT 'update'" do
    it "success with redirect" do
      put :update, params: { id: vanity_url.id, vanity_url: { url: '/abc' } }
      expect(response).to redirect_to('/cms/vanity_urls')
    end

    it "fail with invalid params" do
      put :update, params: { id: vanity_url.id, vanity_url: { redirect_url: '' } }
      expect(response).to render_template(:edit)
    end
  end

  describe "DELETE 'destroy'" do
    it 'delete vanity url' do
      delete :destroy, params: { id: vanity_url.id }
      expect(response).to redirect_to('/cms/vanity_urls')
    end
  end
end
