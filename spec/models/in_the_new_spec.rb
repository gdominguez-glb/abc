require 'rails_helper'

RSpec.describe InTheNew, type: :model do
  it { should validate_presence_of(:title) }
  it { should allow_value('test').for(:title) }
  it { should_not allow_value('test' * 100).for(:title) }
end
