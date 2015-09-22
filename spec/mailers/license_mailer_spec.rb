require 'rails_helper'

RSpec.describe LicenseMailer do
  describe "#notify" do
    it "send notification to license email" do
      licesed_product = create(:spree_licensed_product, user: nil, email: 'john@foooo.com')
      LicenseMailer.notify(licesed_product).deliver_now

      expect(ActionMailer::Base.deliveries.first.to).to eq(['john@foooo.com'])
    end

    it "send notification to license user's email" do
      licesed_product = create(:spree_licensed_product, user: create(:gm_user, email: 'doom@fooo.com'))
      LicenseMailer.notify(licesed_product).deliver_now

      expect(ActionMailer::Base.deliveries.first.to).to eq(['doom@fooo.com'])
    end
  end
end
