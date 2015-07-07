require 'rails_helper'

RSpec.describe Curriculum, type: :model do
  it { should validate_presence_of(:name) }

  it { should have_many(:pages) }
end
