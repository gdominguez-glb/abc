require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  let(:home_page) { create(:page, title: 'Home page', slug: '/') }

  describe "GET 'index'" do
    before { Rails.cache.clear }
    it "success" do
      home_page
      get :index
      expect(response).to be_success
      expect(assigns(:page)).to eq(home_page)
    end
  end

  describe "POST 'turn_off_browser_warning'" do
    it "success" do
      post :turn_off_browser_warning
      expect(session[:turn_off_browser_warning]).to eq('true')
    end
  end
end
