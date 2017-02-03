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

  describe "POST #set_filter_preferences" do
    it 'should set session filter_role with param role' do
      post :set_filter_preferences, role: "rolly"
      expect(session[:filter_role]).to eq("rolly")
    end

    it 'should set session filter_curriculum with param curriculum' do
      post :set_filter_preferences, curriculum: "curriculumy"
      expect(session[:filter_curriculum]).to eq("curriculumy")
    end

    it 'should render nothing' do
      post :set_filter_preferences
      expect(response.body).to render_template(nil)
    end
  end
end
