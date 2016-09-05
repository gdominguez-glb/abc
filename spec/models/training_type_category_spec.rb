require 'rails_helper'

RSpec.describe TrainingTypeCategory, type: :model do
  it { should have_many(:event_trainings) }
  it { should validate_presence_of(:title) }
end
