require 'rails_helper'

RSpec.describe Page, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }
  it { should validate_presence_of(:group_name) }

  it { should belong_to(:curriculum) }
  it { should have_many(:medium_publications) }
  it { should have_many(:event_pages) }
  it { should have_one(:shop).class_name('CurriculumShop') }
  it { should have_one(:custom_css) }

  let(:page) { create(:page, title: 'T', body: 'B') }

  describe ".visibles" do
    let!(:visible_page) { create(:page, visible: true) }

    it "return visible pages" do
      expect(Page.visibles).to include(visible_page)
    end
  end

  describe "#should_index?" do
    it "return false for invisible page" do
      page.visible = false
      expect(page.should_index?).to eq(false)
    end

    it "return true for visible page" do
      page.visible = true
      expect(page.should_index?).to eq(true)
    end
  end

  describe "#search_data" do
    it "return data to index" do
      expect(page.search_data).to eq({ title: 'T', body: 'B', user_ids: [-1] })
    end
  end

  describe "curriculum_nav" do
    let(:curriculum) { create(:curriculum, visible: true) }
    let!(:top_nav_page) { create(:page, visible: true, group_root: true, show_in_nav: true, curriculum: curriculum) }

    it "return curriculum page nav" do
      expect(Page.curriculum_nav).to include(top_nav_page)
    end
  end

  describe ".group_roots" do
    let!(:root_page) { create(:page, group_root: true) }

    it "return root pages" do
      expect(Page.group_roots).to include(root_page)
    end
  end

  describe ".not_group_roots" do
    let!(:non_root_page) { create(:page, group_root: false) }

    it "return non root pages" do
      expect(Page.not_group_roots).to include(non_root_page)
    end
  end

  describe ".show_in_top_navigation" do
    let!(:top_nav_page) { create(:page, visible: true, group_root: true, show_in_nav: true) }

    it "return top nav page" do
      expect(Page.show_in_top_navigation).to include(top_nav_page)
    end
  end

  describe ".show_in_sub_navigation" do
    let!(:sub_nav_page) { create(:page, group_name: 'top nav name', visible: true, group_root: false, show_in_nav: true) }

    it "return sub nav page" do
      expect(Page.show_in_sub_navigation('top nav name')).to include(sub_nav_page)
    end
  end

  describe ".show_in_footer_as_top_links" do
    let!(:top_footer_link) { create(:page, visible: true, group_root: true, show_in_footer: true) }

    it "return top footer link" do
      expect(Page.show_in_footer_as_top_links).to include(top_footer_link)
    end
  end

  describe ".show_in_footer_as_subgroup_links" do
    let!(:sub_footer_link) { create(:page, visible: true, group_root: false, show_in_footer: true, group_name: 'footer link') }

    it "return sub footer link" do
      expect(Page.show_in_footer_as_subgroup_links('footer link')).to include(sub_footer_link)
    end
  end

  describe "#sub_pages" do
    let!(:parent_page) { create(:page, title: 'Math', group_name: 'math', group_root: true, slug: 'math', visible: true) }
    let!(:sub_page) { create(:page, title: 'Overview', group_name: 'math', slug: 'math/overview', visible: true) }

    it "return sub pages by group name" do
      expect(parent_page.sub_pages).to eq([sub_page])
    end
  end

  describe "#available_event_pages" do
    let!(:event_page_with_events) { create(:event_page, page: page, regonline_filter: 'Math', display: true) }
    let!(:event_page_without_events) { create(:event_page, page: page, regonline_filter: 'Upcoming', display: true) }

    before(:each) do
      Geocoder.configure(lookup: :test)
      address_mapping = { 'A,B,C,D' => [{
        'latitude' => 36.4722803,
        'longitude' => -87.3612205,
        'address' => 'B',
        'state' => 'C',
        'state_code' => 'C',
        'country' => 'D',
        'country_code' => 'D'
      }] }
      address_mapping.each do |key, value|
        Geocoder::Lookup::Test.add_stub(key, value)
      end
      create(:regonline_event, client_event_id: 'Math', location_name: 'A', city: 'B', state: 'C', country: 'D')
    end

    it "return event pages with events" do
      expect(page.available_event_pages).to eq([event_page_with_events])
    end
  end

  describe "tiles page body" do
    before(:each) do
      pending
    end

    it "generate page body from tiles" do
      page = build(:page, title: 'A', body: nil, tiles: { rows: [{
            'rowType' => '50/50 Content Image Left',
            'title' => 'Hello',
            'body_text' => '<span>hello body</span>',
            'background_color' => 'green',
            'button_title' => 'hello btn',
            'button_link' => 'http://aa.com',
            'button_target' => '_blank',
            'image_url' => 'http://img.com/123'
          }] })
      page.save
      expect(page.body).to eq("<section class=\"row green-bg\">\n  <div class=\"col-sm-6 col-centered-content\">\n    <div class=\"vertical-center\">\n      <picture>\n        <!--[if IE 9]><video style=\"display: none;\"><![endif]-->\n        <source srcset=\"http://img.com/123\" media=\"(min-width: 361px)\">\n        <!--[if IE 9]></video><![endif]-->\n        <img srcset=\"http://img.com/123\" class=\"img-responsive margin-bottom--xl--sm-min\">\n      </picture>\n    </div>\n  </div>\n  <div class=\"col-sm-6 col-centered-content\">\n    <div class=\"vertical-center\">\n      <h6>Hello</h6>\n      <p>hello body</p>\n      \n        \n          \n        \n        <a class=\"btn btn-default btn-block-xs\" href=\"http://aa.com\" target=\"_blank\">hello btn</a>\n      \n    </div>\n  </div>\n</section>\n")
    end
  end
end
