require 'rails_helper'

RSpec.describe Curriculum, type: :model do
  let(:curriculum) { create(:curriculum) }

  it { should validate_presence_of(:name) }

  it { should have_many(:pages) }

  describe ".visibles" do
    it "return visible curriculum" do
      curriculum = create(:curriculum, visible: true)
      expect(Curriculum.visibles).to include(curriculum)
    end
  end

  describe "#teacher_page" do
    let!(:teachers_page) { create(:page, title: 'Teachers', slug: 'teachers', curriculum: curriculum) }

    it "return page with Teachers title" do
      expect(curriculum.teacher_page).to eq(teachers_page.slug)
    end
  end

  describe "#shop_page" do
    let!(:shop_page) { create(:page, title: 'Shop', slug: 'shop', curriculum: curriculum) }

    it "return page with Shop" do
      expect(curriculum.shop_page).to eq(shop_page.slug)
    end
  end

  describe "#parent_page" do
    let!(:parent_page) { create(:page, title: 'Parents', slug: 'parents', curriculum: curriculum) }

    it "return page with parents" do
      expect(curriculum.parent_page).to eq(parent_page.slug)
    end
  end

  describe "#admin_page" do
    let!(:admin_page) { create(:page, title: 'Admins', slug: 'admins', curriculum: curriculum) }

    it "return page with admins" do
      expect(curriculum.admin_page).to eq(admin_page.slug)
    end
  end
end
