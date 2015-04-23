require 'rails_helper'

RSpec.describe Page, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }
  it { should validate_presence_of(:group_name) }
end
