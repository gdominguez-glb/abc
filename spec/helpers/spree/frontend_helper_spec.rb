require "rails_helper"

RSpec.describe Spree::FrontendHelper, type: :helper do

  let(:product) { create(:product) }
  let(:curriculum) { create(:curriculum, name: 'Math') }

  describe "#flash_messages" do
    let(:flash) { { 'notice' => "This is message with link #{link_to 'Contact Us', contact_path}" } }

    it "output flash message with html safe" do
      flash_messages
      expect(helper.output_buffer).to eq("<div class=\"alert alert-notice\">This is message with link <a href=\"/contact\">Contact Us</a></div>")
    end
  end

  describe "#product_type_class" do
    it "return class with curriculum name if product belong to curriculum" do
      product.curriculum = curriculum
      expect(helper.product_type_class(product)).to eq('label-math')
    end

    it "return label-default if product dont belong to curriculum" do
      product.curriculum = nil
      expect(helper.product_type_class(product)).to eq('label-default')
    end
  end

  describe "#card_type_class" do
    it "returns class with curriculum name if product belongs to curriculum" do
      product.curriculum = curriculum
      expect(helper.card_type_class(product)).to eq('card-math')
    end
  end

  describe "#display_product_price_tag?" do
    it "return false for partner product" do
      product = create(:product, product_type: 'partner')
      expect(helper.display_product_price_tag?(product)).to eq(false)
    end

    it "return false for get in touch product" do
      product = create(:product, product_type: 'get_in_touch', get_in_touch_url: 'http://google.com/abc')
      expect(helper.display_product_price_tag?(product)).to eq(false)
    end

    context "group product" do
      let(:product) { create(:product, product_type: 'group') }

      it "return true for group products with paid items" do
        paid_product_item = create(:product, price: 10)
        create(:spree_group_item, group_id: product, product: paid_product_item)

        expect(helper.display_product_price_tag?(product)).to eq(true)
      end

      it "return false for group product with free items" do
        free_product_item = create(:product, price: 10)
        create(:spree_group_item, group_id: product, product: free_product_item)

        expect(helper.display_product_price_tag?(product)).to eq(true)
      end
    end

    it "return true for normal product" do
      product = create(:product)
      expect(helper.display_product_price_tag?(product)).to eq(true)
    end
  end

  describe "#product_display_price" do
    before(:each) do
      helper.extend(Spree::Core::ControllerHelpers::Store)
    end

    context "FREE" do
      it 'return free for free product' do
        free_product = create(:product, price: 0)
        expect(helper.product_display_price(free_product)).to eq('FREE')
      end

      it "return free for free group product" do
        product = create(:product, product_type: 'group')
        free_product_item = create(:product, price: 10)
        create(:spree_group_item, group_id: product, product: free_product_item)

        expect(helper.product_display_price(product)).to eq('FREE')
      end
    end

    it "return nil for partner product" do
      product = create(:product, product_type: 'partner')
      expect(helper.product_display_price(product)).to eq(nil)
    end
  end
end
