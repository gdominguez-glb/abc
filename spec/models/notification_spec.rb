require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { should belong_to(:notification_trigger) }
  it { should belong_to(:user).class_name('Spree::User') }

  let(:notification) { create(:notification, read: false) }

  describe ".unread" do
    it "return unread notifications" do
      notification
      expect(Notification.unread).to include(notification)
    end
  end

  describe "#mark_as_read!" do
    it "mark notificaiton as read" do
      notification.mark_as_read!
      expect(notification.reload.read).to eq(true)
    end
  end
end
