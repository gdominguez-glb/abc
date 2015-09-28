require "rails_helper"

RSpec.describe SearchHelper, type: :helper do
  describe "#search_result_partial" do
    it "return page_item for Page record" do
      page = create(:page)

      expect(helper.search_result_partial(page)).to eq('page_item')
    end

    it "return product_item for Product record" do
      product = create(:product)

      expect(helper.search_result_partial(product)).to eq('product_item')
    end

    it "return video_item for Video record" do
      video = create(:spree_video)

      expect(helper.search_result_partial(video)).to eq('video_item')
    end

    it "return material_item for Material record" do
      material = create(:spree_material, parent: nil)

      expect(helper.search_result_partial(material)).to eq('material_item')
    end
  end
end
