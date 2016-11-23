require 'rails_helper'

RSpec.describe NotificationTrigger, type: :model do
  it { should have_many(:notifications) }

  it { should belong_to(:single_user).class_name('Spree::User') }
  it { should belong_to(:school_district_admin_user).class_name('Spree::User') }

  it { should validate_presence_of(:notify_at) }
  it { should validate_presence_of(:content) }

  describe "#group_users" do
    let(:user) { create(:gm_user) }
    it "return group users" do
      nt = NotificationTrigger.new(user_ids: [user.id])
      expect(nt.group_users).to eq([user])
    end
  end

  describe "#deliver!" do
    it "mark notification trigger as delivered" do
      nt = create(:notification_trigger)
      nt.deliver!
      expect(nt.reload.status).to eq('delivered')
    end
  end

  describe "target type methods" do
    NotificationTrigger::TARGET_TYPES.each do |target_type|
      it "return true if target type is #{target_type}" do
        nt = create(:notification_trigger, target_type: target_type, school_district_admin_user: create(:gm_user))
        expect(nt.send("#{target_type}_target?")).to eq(true)
      end
    end
  end
end
