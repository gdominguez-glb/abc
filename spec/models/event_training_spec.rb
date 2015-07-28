require 'rails_helper'

RSpec.describe EventTraining, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
end
