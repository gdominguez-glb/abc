require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  let(:home_page) { create(:page, title: 'Home page', slug: '/') }

  describe "GET 'index'" do
    it "success" do
      home_page
      get :index
      expect(response).to be_success
      expect(assigns(:page)).to eq(home_page)
    end
  end
end
