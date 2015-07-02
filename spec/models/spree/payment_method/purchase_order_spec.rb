require 'rails_helper'

RSpec.describe Spree::PaymentMethod::PurchaseOrder, type: :model do
  let(:purchase_order) { Spree::PaymentMethod::PurchaseOrder.new }

  describe "#actions" do
    it "include capture and void" do
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

  describe "#capture" do
    it "capture payment successfully" do
      response = purchase_order.capture
      expect(response.success?).to eq(true)
    end
  end

  describe "#void" do
    it "void payment successfully" do
      response = purchase_order.void
      expect(response.success?).to eq(true)
    end
  end

  describe "#source_required?" do
    it "doesn't require source" do
      expect(purchase_order.source_required?).to eq(false)
    end
  end

  describe "#auto_capture?" do
    it "doesn't auto capture" do
      expect(purchase_order.auto_capture?).to eq(false)
    end
  end

  describe "#payment_source_class" do
    it "use purchase order as source" do
      expect(purchase_order.payment_source_class).to eq(Spree::PurchaseOrder)
    end
  end

  describe "#purchase" do
    it "purchase successfully" do
      response = purchase_order.purchase(1000, nil)
      expect(response.success?).to eq(true)
    end
  end
end
