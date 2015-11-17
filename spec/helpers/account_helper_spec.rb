require "rails_helper"

RSpec.describe AccountHelper, type: :helper do
  describe "#activity_item_link" do
    describe "page activity" do
      let(:page) { create(:page, slug: 'hello') }
      let(:activity) { create(:activity, item: page) }

      it "return page url" do
        expect(helper.activity_item_link(activity)).to eq('/hello')
      end
    end

    describe "product activity" do
      let(:product) { create(:product, slug: 'hello-one') }
      let(:activity) { create(:activity, item: product) }

      it "return product url" do
        expect(helper.activity_item_link(activity)).to eq("/store/products/hello-one")
      end
    end

    describe "material activity" do
      let!(:product) { create(:product, access_url: 'http://greatminds.net/this_is_product') }
      let!(:material) { create(:spree_material, product: product, parent: nil) }
      let!(:activity) { create(:activity, item: material) }

      it "return product access url" do
        expect(helper.activity_item_link(activity)).to eq("http://greatminds.net/this_is_product?opened_material_id=#{material.id}&opened_product_id=#{product.id}")
      end
    end
  end
end
