require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  let!(:job) { create(:job, display: true) }

  describe "GET 'index'" do
    let!(:careers_page) { create(:page, slug: 'careers') }

    it "be success" do
      get :index
      expect(response).to be_success
      expect(assigns(:careers_page)).to eq(careers_page)
      expect(assigns(:jobs)).to eq([job])
    end
  end

  describe "GET 'show'" do
    it "success" do
      get :show, id: job.id
      expect(response).to be_success
      expect(assigns(:job)).to eq(job)
    end
  end
end
