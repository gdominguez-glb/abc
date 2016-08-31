require 'rails_helper'

RSpec.describe Spree::UserSessionsController, type: :controller do
  describe "GET 'become'" do
    let(:regular_user) { create(:gm_user) }

    context 'when logged in as an admin' do
      login_admin

      it 'becomes user' do
        get :become, id: regular_user.id
        expect(response).to redirect_to '/account'
        expect(flash[:notice]).to eq "Now logged in as #{regular_user.email}"
      end

      it "redirect if user not exist" do
        get :become, id: 100000
        expect(response).to redirect_to '/account'
        expect(flash[:notice]).to eq "Could not find user"
      end

      it "redirect if try to become self" do
        get :become, id: controller.current_spree_user.id
        expect(response).to redirect_to '/account'
        expect(flash[:notice]).to eq "Already logged in as #{controller.current_spree_user.email}"
      end

      it "could not switch to admin" do
        another_admin = create(:gm_user)
        another_admin.spree_roles << Spree::Role.admin

        get :become, id: another_admin.id
        expect(response).to redirect_to '/account'
        expect(flash[:notice]).to eq "Cannot change to admin"
      end
    end

    context 'when logged in as a regular user' do
      login_user

      it 'prevents becoming another user' do
        get :become, id: regular_user.id
        expect(response).to redirect_to '/account'
        expect(flash[:notice]).to eq 'Permission denied'
      end
    end
  end

  describe "POST 'create'" do
    include Spree::TestingSupport::ControllerRequests

    before { @request.env["devise.mapping"] = Devise.mappings[:spree_user] }

    before(:each) { create(:gm_user, email: 'johndoe@foo.com', password: '123456', password_confirmation: '123456') }

    it "login with correct credential" do
      spree_post :create, spree_user: { email: 'johndoe@foo.com', password: '123456' }
      expect(response).to redirect_to('/account')
    end

    it "not login with incorrect credential" do
      spree_post :create, spree_user: { email: 'johndoe@foo.com', password: '111111' }
      expect(response).to render_template(:new)
    end
  end

  describe "DELETE 'destroy'" do
    include Spree::TestingSupport::ControllerRequests

    before { @request.env["devise.mapping"] = Devise.mappings[:spree_user] }
    login_user

    it "sign out user" do
      spree_delete :destroy
      expect(response).to redirect_to('/')
      expect(controller.current_spree_user).to eq(nil)
    end
  end
end
