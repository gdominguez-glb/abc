require 'rails_helper'

RSpec.describe Spree::LicensedProduct, type: :model do

  it { should belong_to(:product).class_name('Spree::Product') }
  it { should belong_to(:order).class_name('Spree::Order') }
  it { should belong_to(:user).class_name('Spree::User') }

  it { should validate_numericality_of(:quantity) }
  it { should allow_value('john@doe.com').for(:email) }
  it { should_not allow_value('johndoe.com').for(:email) }

  describe "#distribute_license" do
    let(:licensed_product) { create(:spree_licensed_product) }
    let(:to_user) { create(:user, skip_salesforce_create: true, email: 'john123@doe.com', first_name: 'John', last_name: 'Doe', school_district: create(:school_district) ) }

    it "distribute license to user" do
      distribution = licensed_product.distribute_license(to_user)
      expect(distribution.to_user).to eq(to_user)
    end

    it "distribute license to email" do
      distribution = licensed_product.distribute_license('john@doe.com')
      expect(distribution.email).to eq('john@doe.com')
    end

    it "increase quantity on exist distribution if exist same license distribution" do
      distribution = licensed_product.distribute_license('john@doe.com', 2)
      licensed_product.distribute_license('john@doe.com', 2)
      expect(distribution.reload.quantity).to eq(4)
    end
  end

  describe "set user from email" do
    it "set user with email in license" do
      user = create(:gm_user, email: 'hello@foo.com')
      licensed_product = create(:spree_licensed_product, email: 'hello@foo.com', user: nil)
      expect(licensed_product.user).to eq(user)
    end
  end
end
