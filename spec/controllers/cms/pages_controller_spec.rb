require 'rails_helper'

RSpec.describe Cms::PagesController, type: :controller do
  let(:page) { create(:page) }

  login_admin

  # describe "GET 'index'" do
  #   it "success" do
  #     get :index
  #     expect(response).to be_success
  #     expect(assigns(:pages)).not_to be_nil
  #   end
  # end

  describe "GET 'show'" do

    it "success" do
      get :show, id: page.id
      expect(response).to be_success
      expect(assigns(:page)).not_to be_nil
    end
  end

  describe "GET 'new'" do
    it "success" do
      get :new
      expect(response).to be_success
      expect(assigns(:page)).not_to be_nil
    end
  end

  describe "POST 'create'" do
    it "success" do
      post :create, page: { title: 'a', slug: 'b', group_name: 'c' }
      expect(response).to be_redirect
    end

    it "fail" do
      post :create, page: { title: '' }
      expect(response).to render_template(:new)
    end
  end

  describe "GET 'edit'" do
    it "success" do
      get :edit, id: page.id
      expect(response).to be_success
      expect(assigns(:page)).not_to be_nil
    end
  end

  describe "PUT 'update'" do
    it "update successfully" do
      put :update, id: page.id, page: { title: 'new title' }
      expect(response).to be_redirect
    end

    it "fail to update" do
      put :update, id: page.id, page: { title: '' }
      expect(response).to render_template(:edit)
    end
  end

  describe "DELETE 'destroy'" do
    it "destroy successfully" do
      delete :destroy, id: page.id
      expect(response).to be_redirect
      expect(Page.find_by(id: page.id)).to be_nil
    end
  end
end
