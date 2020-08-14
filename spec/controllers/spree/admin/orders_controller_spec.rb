require 'rails_helper'

RSpec.describe Spree::Admin::OrdersController, type: :controller do
  routes { Spree::Core::Engine.routes }
  login_admin

  let(:user) { create(:gm_user) }

  describe "GET 'index'" do

    before do
      create(:order, user: user, completed_at: 3.hours.ago, state: 'complete')
      create(:order, user: user, completed_at: 4.hours.ago, state: 'cart')
      create(:order, user: user, completed_at: 4.hours.ago, state: 'returned')
    end

    it "Should return all complete orders by default" do
      get :index
      expect(assigns(:orders)).not_to be_empty
    end

    it "Should return orders with a range" do
      get :index, params: {
                            q: {
                                  'created_at_gt'=>5.days.ago.strftime('%Y/%m/%d'),
                                  'created_at_lt'=> Date.tomorrow.strftime('%Y/%m/%d')
                                }
                          }
      expect(assigns(:orders)).not_to be_empty
    end
  end
end
