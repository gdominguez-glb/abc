require 'rails_helper'

RSpec.describe Spree::Video, type: :model do
  it { should belong_to(:video_group).class_name('Spree::VideoGroup') }
  it { should have_many(:video_classifications) }
  it { should have_many(:taxons) }

  it { should validate_presence_of(:title) }

  let(:video) { create(:spree_video, title: 'G4M2 TA L1') }

  def set_free_premium_taxons
    free_taxonomy = create(:taxonomy, name: 'Free?')
    create(:taxon, name: 'Free', taxonomy: free_taxonomy)
    create(:taxon, name: 'Premium', taxonomy: free_taxonomy)
  end

  def set_taxons
    grade_taxonomy  = create(:taxonomy, name: 'Grade')
    module_taxonomy = create(:taxonomy, name: 'Module')
    topic_taxonomy  = create(:taxonomy, name: 'Topic')
    lesson_taxonomy = create(:taxonomy, name: 'Lesson')

    create(:taxon, name: '4', taxonomy: grade_taxonomy)
    create(:taxon, name: '2', taxonomy: module_taxonomy)
    create(:taxon, name: 'A', taxonomy: topic_taxonomy)
    create(:taxon, name: '1', taxonomy: lesson_taxonomy)
  end

  describe "video group" do
    it "create video group with name" do
      video = create(:spree_video, video_group_name: 'VG 1')
      expect(video.video_group.name).to eq('VG 1')
    end
  end

  describe "#products" do
    let!(:video_group) { create(:spree_video_group, name: 'VG 2') }
    let!(:product) { create(:product, video_group: video_group) }
    let(:video) { create(:spree_video, video_group_name: 'VG 2') }

    it "return products associate with video group" do
      expect(video.products).to eq([product])
    end
  end

  describe "#analyze_taxons" do
    before(:each) do
      set_taxons
    end

    it "assign taxons based on video title" do
      video.analyze_taxons

      expect(video.taxons.find_by(name: '4')).not_to be_nil
      expect(video.taxons.find_by(name: '2')).not_to be_nil
      expect(video.taxons.find_by(name: 'A')).not_to be_nil
      expect(video.taxons.find_by(name: '1')).not_to be_nil
    end
  end

  describe "#categories" do
    before(:each) do
      set_taxons
    end

    it "return taxonomy names of video" do
      video.analyze_taxons

      expect(video.categories).to eq(["Grade", "Module", "Topic", "Lesson"])
    end
  end

  describe "#update_wistia_data" do
    it "update wistia data with media data" do
      media_data = { 'id' => '123321', 'hashed_id' => 'abc123', 'status' => 'ready' }
      video.update_wistia_data(media_data)

      expect(video.wistia_id).to eq(123321)
      expect(video.wistia_hashed_id).to eq('abc123')
      expect(video.wistia_status).to eq('ready')
    end
  end

  describe "#wistia_ready?" do
    it "return true when wistia status is ready" do
      video.wistia_status = 'ready'

      expect(video.wistia_ready?).to eq(true)
    end

    it "return false when wistia status is not ready" do
      video.wistia_status = 'pending'

      expect(video.wistia_ready?).to eq(false)
    end
  end

  describe "free/premium taxons" do
    before(:each) do
      set_free_premium_taxons
    end

    it "assign free taxon when is_free is true" do
      video.update(is_free: true)

      expect(video.taxons.find_by(name: 'Free')).not_to be_nil
      expect(video.taxons.find_by(name: 'Premium')).to be_nil
    end

    it "assign premium when is_free is false" do
      video.update(is_free: false)

      expect(video.taxons.find_by(name: 'Free')).to be_nil
      expect(video.taxons.find_by(name: 'Premium')).not_to be_nil
    end
  end
end
