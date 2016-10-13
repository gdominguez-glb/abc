require 'rails_helper'

RSpec.describe TeamController, type: :controller do
  let!(:staff) { create(:staff, display: true, staff_type: 0) }
  let!(:trustee) { create(:staff, display: true, staff_type: 1) }

  describe "GET 'index'" do
    it "list all staffs" do
      get :index

      expect(response).to be_success
      expect(assigns(:staffs)).to eq([staff])
    end
  end

  describe "GET 'trustees'" do
    it "list all trustees" do
      get :trustees

      expect(response).to be_success
      expect(assigns(:trustees)).to eq([trustee])
    end
  end
end
