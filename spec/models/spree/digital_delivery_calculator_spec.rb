require 'rails_helper'

RSpec.describe Spree::Calculator::Shipping::DigitalDelivery do

  it "always available" do
    shipping = Spree::Calculator::Shipping::DigitalDelivery.new

    expect(shipping.available?(nil)).to eq(true)
  end
end
