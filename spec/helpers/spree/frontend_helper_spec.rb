require "rails_helper"

RSpec.describe Spree::FrontendHelper, type: :helper do

  let(:product) { create(:product) }
  let(:curriculum) { create(:curriculum, name: 'Math') }

  describe "#product_type_class" do
    it "return class with curriculum name if product belong to curriculum" do
      product.curriculum = curriculum
      expect(helper.product_type_class(product)).to eq('label-math')
    end

    it "return nil if product dont belong to curriculum" do
      product.curriculum = nil
      expect(helper.product_type_class(product)).to eq(nil)
    end
  end
end
