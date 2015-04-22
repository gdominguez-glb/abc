require 'rails_helper'

RSpec.describe Contact, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:message) }

  it { should allow_value('test@foo.com').for(:email) }
  it { should_not allow_value('test').for(:email) }
  it { should_not allow_value(nil).for(:email) }
end
