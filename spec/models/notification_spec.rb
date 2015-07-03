require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { should belong_to(:notification_trigger) }
  it { should belong_to(:user).class_name('Spree::User') }
end
