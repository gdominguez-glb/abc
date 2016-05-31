require 'rails_helper'

RSpec.describe Recommendation, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:sub_header) }
  it { should validate_presence_of(:call_to_action_button_text) }
  it { should validate_presence_of(:call_to_action_button_link) }

  it { should have_and_belong_to_many(:products).class_name('Spree::Product') }

  describe ".with_subject" do
    it "return recommendation with subject" do
      recommendation = create(:recommendation, subject: 'Math')
      expect(Recommendation.with_subject('Math')).to include(recommendation)
    end
  end

  describe ".filter_by_subject_or_user_title" do
    before(:each) do
      @math_parent = create(:recommendation, subject: 'Math', user_title: 'Parent')
      @english_teacher = create(:recommendation, subject: 'English', user_title: 'Teacher')
    end

    it "filter by both subjects and user_title" do
      expect(Recommendation.filter_by_subject_or_user_title(['Math'], 'Parent')).to eq([@math_parent])
    end

    it "filter by only subjects" do
      expect(Recommendation.filter_by_subject_or_user_title(['English'], nil)).to eq([@english_teacher])
    end

    it "filter by only user_title" do
      expect(Recommendation.filter_by_subject_or_user_title([], 'Teacher')).to eq([@english_teacher])
    end

    it "return all if all empty" do
      expect(Recommendation.filter_by_subject_or_user_title([], nil).order(:subject)).to eq([@english_teacher, @math_parent])
    end
  end

  describe "#icon_image" do
    it "icon image url" do
      recommendation = create(:recommendation, subject: 'Math', icon: 'BLOG')
      expect(recommendation.icon_image).to eq("recommendations/BLOG.png")
    end
  end
end
