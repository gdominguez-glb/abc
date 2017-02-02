require 'rails_helper'

RSpec.describe VanityUrl, type: :model do
  it { should validate_presence_of(:url) }
  it { should validate_uniqueness_of(:url) }
  it { should validate_presence_of(:redirect_url) }
  it { should_not allow_value('http://test.foo/').for(:url) }
  it { should_not allow_value('http://test.foo/store').for(:url) }

  it_behaves_like "categorizable"
end
