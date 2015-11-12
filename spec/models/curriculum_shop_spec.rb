require 'rails_helper'

RSpec.describe CurriculumShop, type: :model do
  it { should belong_to(:page) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:page_id) }
end
