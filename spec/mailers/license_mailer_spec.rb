require 'rails_helper'

RSpec.describe LicenseMailer do
  let(:product) { create(:product, name: 'Curriculum') }

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

  # describe "#notify_fulfillment" do
  #   let(:order) { create(:order, email: 'test@foo.com', user: nil) }

  #   context "single product" do
  #     let!(:single_line_item) { create(:line_item, order: order, variant: product.master, quantity: 1) }
  #     let(:mail) { LicenseMailer.notify_fulfillment(order) }

  #     it "send to correct email" do
  #       expect(mail.to).to eq(['test@foo.com'])
  #     end

  #     it "set correct subject" do
  #       expect(mail.subject).to eq("Great Minds Customer Service has given you access to Curriculum")
  #     end

  #     it "generate correct body" do
  #       expect(mail.body.encoded).to match('store/signup')
  #     end
  #   end

  #   context "multiple products" do
  #     let!(:single_line_item) { create(:line_item, order: order, variant: product.master, quantity: 2) }
  #     let(:mail) { LicenseMailer.notify_fulfillment(order) }

  #     it "send to correct email" do
  #       expect(mail.to).to eq(['test@foo.com'])
  #     end

  #     it "set correct subject" do
  #       expect(mail.subject).to eq('Great Minds Customer Service has assigned you Curriculum licenses to distribute')
  #     end

  #     it "set correct body" do
  #       expect(mail.body.encoded).to match('Log in or create an account')
  #     end
  #   end
  # end

  # describe "#notify_other_admin" do
  #   let(:user) { create(:gm_user, email: 'john@foo.com', first_name: 'John', last_name: 'Foo') }
  #   let(:order) { create(:order, license_admin_email: 'other@foo.com', user: user) }
  #   let!(:line_item) { create(:line_item, order: order, variant: product.master, quantity: 1) }
  #   let(:mail) { LicenseMailer.notify_other_admin(order) }

  #   it "send to correct email" do
  #     expect(mail.to).to eq(['other@foo.com'])
  #   end

  #   it "set correct subject" do
  #     expect(mail.subject).to eq('John Foo has made you a Great Minds Administrator')
  #   end

  #   it "set correct body" do
  #     expect(mail.body.encoded).to match('has made you the administrator')
  #   end
  # end

  describe "#notify_distribution" do
    let!(:school_admin) { create(:gm_user, first_name: 'John', last_name: 'Doe') }

    context "single" do
      let(:mail) { LicenseMailer.notify_distribution({to_email: 'user@foo.com', quantity: 1, product_name: product.name, school_admin: school_admin}) }

      it "set correct email" do
        expect(mail.to).to eq(['user@foo.com'])
      end

      it "set correct subject" do
        expect(mail.subject).to eq('John Doe has given you access to Curriculum')
      end

      it "set correct body" do
        expect(mail.body.encoded).to match('To activate your account')
      end
    end

    context "multiple" do
      let(:mail) { LicenseMailer.notify_distribution({to_email: 'user@foo.com', quantity: 2, product_name: product.name, school_admin: school_admin}) }

      it "set correct email" do
        expect(mail.to).to eq(['user@foo.com'])
      end

      it "set correct subject" do
        expect(mail.subject).to eq('John Doe has assigned you Curriculum licenses to distribute')
      end

      it "set correct body" do
        expect(mail.body.encoded).to match('Log in or create an account')
      end
    end
  end
end
