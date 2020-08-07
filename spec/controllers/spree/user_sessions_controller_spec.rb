require 'rails_helper'

RSpec.describe Spree::UserSessionsController, type: :controller do
  describe "GET 'become'" do
    let(:regular_user) { create(:gm_user) }

    context 'when logged in as an admin' do
      login_admin

      it 'becomes user' do
        get :become, params: { id: regular_user.id }
        expect(response).to redirect_to '/account'
        expect(flash[:notice]).to eq "Now logged in as #{regular_user.email}"
      end

      it "redirect if user not exist" do
        get :become, params: { id: 100000 }
        expect(response).to redirect_to '/account'
        expect(flash[:notice]).to eq "Could not find user"
      end

      it "redirect if try to become self" do
        get :become, params: { id: controller.current_spree_user.id }
        expect(response).to redirect_to '/account'
        expect(flash[:notice]).to eq "Already logged in as #{controller.current_spree_user.email}"
      end

      it "could not switch to admin" do
        another_admin = create(:gm_user)
        another_admin.spree_roles << Spree::Role.admin

        get :become, params: { id: another_admin.id }
        expect(response).to redirect_to '/account'
        expect(flash[:notice]).to eq "Cannot change to admin"
      end
    end

    context 'when logged in as a regular user' do
      login_user

      it 'prevents becoming another user' do
        get :become, params: { id: regular_user.id }
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

  describe 'GET lti' do
    before { @request.env["devise.mapping"] = Devise.mappings[:spree_user] }

    before :each do
      @app = create :application, name: 'test', scopes: 'public'
      @token = create :access_token, resource_owner_id: nil, application: @app
    end

    it 'decrypt and create a session to access Eureka' do
      user = create :gm_user

      json_response = {
        id: user.id,
        token: @token.token
      }.to_json


      get :lti, params: { spree_user: {
                          id: Cypher.encrypt(json_response),
                          redirect_to: 'https://staging.eureka.greatminds.org'
                        } }
      expect(subject).to redirect_to('https://staging.eureka.greatminds.org')
    end

    it 'fail when the user doesn\'t exists' do
      json_response = {
        id: 129395729,
        token: @token.token
      }.to_json


      get :lti, params: { spree_user: {
                          id: Cypher.encrypt(json_response),
                          redirect_to: 'https://staging.eureka.greatminds.org'
                        } }

      expect(response.status).to eq(500)
      expect(response.body).to eq('User not found')
    end

    it 'fail when the id isnt valid' do
      get :lti, params: { spree_user: {
                          id: 'invalid string',
                          redirect_to: 'https://staging.eureka.greatminds.org',
                          token: @token.token
                        } }

      expect(response.status).to eq(500)
      expect(response.body).to eq('Invalid id')
    end

    it 'fail when the token is invalid' do
      user = create :gm_user

      json_response = {
        id: user.id,
        token: 'invalid token'
      }.to_json

      get :lti, params: { spree_user: {
                          id: Cypher.encrypt(json_response),
                          redirect_to: 'https://staging.eureka.greatminds.org'
                        } }

      expect(response.status).to eq(500)
      expect(response.body).to eq('Token expired')
    end

    it 'fail when the token is expired' do
      token = create :access_token,
                     resource_owner_id: nil,
                     application: @app,
                     expires_in: 1
      sleep 1
      user = create :gm_user

      json_response = {
        id: user.id,
        token: token.token
      }.to_json

      get :lti, params: { spree_user: {
                          id: Cypher.encrypt(json_response),
                          redirect_to: 'https://staging.eureka.greatminds.org'
                        } }

      expect(response.status).to eq(500)
      expect(response.body).to eq('Token expired')
    end
  end
end
