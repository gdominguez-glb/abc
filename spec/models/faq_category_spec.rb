require 'rails_helper'

RSpec.describe FaqCategory, type: :model do
  it { should have_many(:questions) }

  it { should validate_presence_of(:name) }
end
