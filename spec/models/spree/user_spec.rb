require 'rails_helper'

RSpec.describe Spree::User do
  let(:user_attributes) { {skip_salesforce_create: true, first_name: 'John', last_name: 'Doe', school_district: create(:school_district)} }
  let(:user) { create(:user, user_attributes) }

  it { should belong_to(:school_district) }
  it { should have_many(:completed_orders).class_name('Spree::Order') }
  it { should have_many(:products).class_name('Spree::Product') }
  it { should have_many(:licensed_products).class_name('Spree::LicensedProduct') }
  it { should have_many(:notifications) }
  it { should have_many(:activities) }
  it { should have_many(:product_tracks) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

  it { should allow_value('1231asfsdf@#@#').for(:password) }
  it { should_not allow_value('  1231asfsdf@#@#').for(:password) }

  it "has default user role" do
    expect(user.spree_roles.first).to eq(Spree::Role.user)
  end

  describe "#has_admin_role?" do
    it "return false for admin" do
      user.spree_roles << Spree::Role.admin
      expect(user.has_admin_role?).to eq(true)
    end
  end

  describe "assign_licenses" do
    let!(:licensed_product) { create(:spree_licensed_product, email: 'john@doe.com') }

    it "assign license to register user for same email" do
      user = create(:user, user_attributes.merge(email: 'john@doe.com'))
      expect(user.licensed_products.first).to eq(licensed_product)
    end
  end

  describe "#full_name" do
    it "combind first and last name" do
      expect(user.full_name).to eq("John Doe")
    end
  end
end
