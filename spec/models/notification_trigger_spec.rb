require 'rails_helper'

RSpec.describe NotificationTrigger, type: :model do
  it { should have_many(:notifications) }
end
