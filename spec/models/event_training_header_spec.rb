require 'rails_helper'

RSpec.describe EventTrainingHeader, type: :model do
  it { should belong_to :training_type_category }
  it { should have_many :event_trainings }

  it { should validate_presence_of :name }
end
