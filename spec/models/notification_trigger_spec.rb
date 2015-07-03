require 'rails_helper'

RSpec.describe NotificationTrigger, type: :model do
  it { should have_many(:notifications) }

  it { should validate_presence_of(:notify_at) }
  it { should validate_presence_of(:content) }
end
