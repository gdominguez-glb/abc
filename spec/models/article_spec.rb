require 'rails_helper'

RSpec.describe Article, type: :model do
  it { should belong_to(:blog) }

  it { should validate_presence_of(:title) }
  it { should allow_value('test').for(:title) }
  it { should_not allow_value('test' * 100).for(:title) }

  it { should validate_presence_of(:body_draft) }
  it { should validate_presence_of(:slug) }
end
