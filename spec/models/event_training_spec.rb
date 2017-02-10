require 'rails_helper'

RSpec.describe EventTraining, type: :model do
  it { should belong_to(:training_type_category) }
  it { should belong_to(:event_training_header) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }

  let(:event_training) { create(:event_training, title: 'This is a event training', content: 'test') }

  describe "#title_to_slug" do
    it "generate slug from title" do
      expect(event_training.title_to_slug).to eq('this-is-a-event-training')
    end
  end

  describe "#search_data" do
    it "index title and content" do
      expect(event_training.search_data).to eq({
        title: 'This is a event training',
        content: 'test',
        user_ids: [-1]
      })
    end
  end

  describe "#title_with_category" do
    it "display title with category" do
      event_training.title = 'A'
      event_training.category = 'B'
      expect(event_training.title_with_category).to eq('A - B')
    end
  end
end
