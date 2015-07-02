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
  end
end
