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

    it "return post_item for Post record" do
      _post = create(:post)
      expect(helper.search_result_partial(_post)).to eq('post_item')
    end
  end

  describe "#material_link" do
    it "return product path of material" do
      product = create(:product)
      material = create(:spree_material, product: product)

      expect(helper.material_link(material)).to eq("/store/products/#{product.slug}")
    end

    it "return to access url if present" do
      product = create(:product, access_url: 'http://test.foo/123')
      material = create(:spree_material, product: product)

      expect(helper.material_link(material)).to eq("http://test.foo/123?opened_material_id=#{material.id}&opened_product_id=#{product.id}")
    end
  end

  describe "#post_link" do
    let(:global_medium_publication) { create(:medium_publication, blog_type: 'global', title: 'global', slug: 'test', url: 'http://test.com') }
    let(:math_page) { create(:page, title: 'Math', slug: 'math') }
    let(:curriculum_medium_publication) { create(:medium_publication, page: math_page, blog_type: 'curriculum', title: 'report', slug: 'report', url: 'http://test.com') }

    it "return global post link for global medium publication" do
      _post = create(:post, medium_publication: global_medium_publication)

      expect(helper.post_link(_post)).to eq("/updates/global/test/post/#{_post.slug}")
    end

    it "return curriculum post link for curriculum medium publication" do
      _post = create(:post, medium_publication: curriculum_medium_publication)

      expect(helper.post_link(_post)).to eq("/math/blog/report/post/#{_post.slug}")
    end
  end

  describe "#event_page_link" do
    describe "global event link" do
      let(:event_page) { create(:event_page, slug: 'this-is-global-events', event_page_type: :global) }

      it "generate global link" do
        expect(helper.event_page_link(event_page)).to eq('/events/l/this-is-global-events')
      end
    end

    describe "curriculum link" do
      let(:page) { create(:page, slug: 'math') }
      let(:event_page) { create(:event_page, slug: 'this-is-math-events', event_page_type: :curriculum, page: page) }

      it "generate curriculum link" do
        expect(helper.event_page_link(event_page)).to eq("/math/events/this-is-math-events")
      end
    end
  end
end
