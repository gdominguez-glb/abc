require 'rails_helper'

RSpec.describe Spree::CheckoutController, type: :controller do
  let(:user) { create(:gm_user) }

  describe "#completion_route" do
    let(:free_order) { create(:order, user: user, total: 0) }
    let(:paid_order) { create(:order, user: user, total: 100.0) }

    it 'return account root path with free order' do
      controller.instance_variable_set(:@order, free_order)

      expect(controller.completion_route).to eq('/account')
    end

    it 'return complete order path with paid order' do
      controller.instance_variable_set(:@order, paid_order)

      expect(controller.completion_route).to eq("/resources/orders/#{paid_order.number}/completed")
    end
  end
end
