require 'rails_helper'

RSpec.describe TrainingTypeCategory, type: :model do
  it { should have_many(:event_trainings) }
  it { should have_many(:event_training_headers) }
  it { should validate_presence_of(:title) }

  describe ".default_category" do
    it "return default category" do
      category = create(:training_type_category, is_default: true)
      expect(TrainingTypeCategory.default_category).to eq(category)
    end
  end
end
