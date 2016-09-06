require 'rails_helper'

RSpec.describe MediumPublication, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:slug) }

  it { should have_many(:posts) }
  it { should belong_to(:page) }

  let(:medium_publication) { create(:medium_publication) }

  describe "#global?" do
    it "return true when blog type is global" do
      medium_publication.blog_type = 'global'
      expect(medium_publication.global?).to eq(true)
    end

    it "return false when blog type is not global" do
      medium_publication.blog_type = 'curriculum'
      expect(medium_publication.global?).to eq(false)
    end
  end

  describe "#curriculum?" do
    it "return true when blog type is curriculum" do
      medium_publication.blog_type = 'curriculum'
      expect(medium_publication.curriculum?).to eq(true)
    end

    it "return false when blog type is not curriculum" do
      medium_publication.blog_type = 'global'
      expect(medium_publication.curriculum?).to eq(false)
    end
  end

  describe "#should_index?" do
    it "return true when displayable" do
      medium_publication.display = true
      expect(medium_publication.should_index?).to eq(true)
    end

    it "return false when not displayable" do
      medium_publication.display = false
      expect(medium_publication.should_index?).to eq(false)
    end
  end

  describe "#search_data" do
    it "return search data to index" do
      medium_publication = create(:medium_publication, title: 'Eureka Math')
      expect(medium_publication.search_data).to eq({
        title: 'Eureka Math',
        feature: 'blog',
        user_ids: [-1]
      })
    end
  end
end
