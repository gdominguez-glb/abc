require 'rails_helper'

RSpec.describe Page, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }
  it { should validate_presence_of(:group_name) }

  it { have_many(:medium_publications) }

  describe ".visibles" do
    let!(:visible_page) { create(:page, visible: true) }

    it "return visible pages" do
      expect(Page.visibles).to include(visible_page)
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
end
