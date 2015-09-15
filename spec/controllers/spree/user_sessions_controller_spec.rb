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
end
