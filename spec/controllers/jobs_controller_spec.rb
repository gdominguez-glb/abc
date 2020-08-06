require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  let!(:job) { create(:job, display: true) }

  describe "GET 'index'" do
    let!(:careers_page) { create(:page, slug: 'careers') }

    it "be success" do
      get :index
      expect(response).to redirect_to("https://greatminds.recruitee.com/#/")
    end
  end

  describe "GET 'show'" do
    it "success" do
      get :show, params: { id: job.id }
      expect(response).to redirect_to("https://greatminds.recruitee.com/#/")
    end
  end
end
