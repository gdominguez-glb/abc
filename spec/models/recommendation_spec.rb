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
end
