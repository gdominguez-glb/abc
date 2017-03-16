require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { should belong_to(:notification_trigger) }
  it { should belong_to(:user).class_name('Spree::User') }

  let(:user) { create(:gm_user) }
  let(:notification) { create(:notification, read: false, content: 'hello', user: user) }

  describe '#scopes' do
    it "return unread notifications" do
      notification
      expect(Notification.unread).to include(notification)
    end

    context 'should validate #unexpire' do
      it 'should return notifications with nil value' do
        nil_notification = FactoryGirl.create(:notification, expire_at: nil)
        non_expirable_notification = FactoryGirl.create(:notification, expire_at: 10.minutes.since)
        expect(Notification.unexpire.first).to eq(nil_notification)
      end

      it 'should return unexpired notifications' do
        non_expirable_x = FactoryGirl.create(:notification, expire_at: 5.minutes.since)
        non_expirable_y = FactoryGirl.create(:notification, expire_at: 10.minutes.since)
        nilable = FactoryGirl.create(:notification, expire_at: nil)
        expirable = FactoryGirl.create(:notification, expire_at: 5.minutes.ago)

        notifications = Notification.unexpire

        expect(notifications.count).to eq(3)
        expect(notifications.first).to eq(non_expirable_x)
        expect(notifications.last).to eq(nilable)
      end

      it 'should return nothing' do
        (0..5).each { |minutes| FactoryGirl.create(:notification, expire_at: minutes.minutes.ago) }
        expect(Notification.unexpire.count).to eq(0)
      end
    end
  end

  describe "#mark_as_read!" do
    it "mark notificaiton as read" do
      notification.mark_as_read!
      expect(notification.reload.read).to eq(true)
    end
  end
end
