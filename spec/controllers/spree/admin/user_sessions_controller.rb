require 'rails_helper'

RSpec.describe Spree::Admin::UserSessionsController, type: :controller do
  login_admin

  describe "DELETE 'destroy'" do
    it "log out admin without notice" do
      delete :destroy

      expect(response).to be_redirect
      expect(flash[:notice]).to be_nil
    end
  end
end
