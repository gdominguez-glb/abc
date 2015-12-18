require 'rails_helper'

RSpec.describe Spree::PurchaseOrder, type: :model do
  let(:purchase_order) { Spree::PurchaseOrder.new }

  it { should belong_to(:payment_method) }
  it { should belong_to(:user).class_name('Spree::User') }
  it { should have_many(:payments) }

  # it { should validate_presence_of(:po_number) }

  describe "#actions" do
    it "return capture and void" do
      expect(purchase_order.actions).to eq(['capture', 'void'])
    end
  end

  describe "#can_capture?" do
    it "return true for checkout payment" do
      payment = double("Payment", state: 'checkout')
      expect(purchase_order.can_capture?(payment)).to eq(true)
    end

    it "return true for pending payment" do
      payment = double("Payment", state: 'pending')
      expect(purchase_order.can_capture?(payment)).to eq(true)
    end

    it "return false for void payment" do
      payment = double("Payment", state: 'void')
      expect(purchase_order.can_capture?(payment)).to eq(false)
    end
  end

  describe "#can_void?" do
    it "return false for void payment" do
      payment = double("Payment", state: 'void')
      expect(purchase_order.can_void?(payment)).to eq(false)
    end

    it "return true for pending payment" do
      payment = double("Payment", state: 'pending')
      expect(purchase_order.can_void?(payment)).to eq(true)
    end
  end
end
