require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  let(:page) { create(:page, title: 'ABC', slug: 'abc', layout: nil, publish_status: :published) }

  describe "not exist page" do
    it "redirect to not found" do
      get :show, params: {slug: 'not-found'}
      expect(response).to redirect_to('/not-found')
    end
  end

  describe "exist page" do
    it "success" do
      get :show, params: {slug: page.slug}
      expect(response).to be_success
      expect(assigns(:page)).to eq(page)
      expect(assigns(:page_title)).to eq(page.title)
    end
  end

  describe "GET 'not_found'" do
    it "success" do
      get :not_found
      expect(response.status).to eq(404)
    end
  end
end
