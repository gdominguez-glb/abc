require 'rails_helper'

RSpec.describe Spree::User do
  let(:user_attributes) { {first_name: 'John', last_name: 'Doe', school_district: create(:school_district)} }
  let(:admin_user) { create(:admin_user, user_attributes) }
  let(:user) { create(:user, user_attributes) }

  it { should belong_to(:school_district) }
  it { should have_many(:completed_orders).class_name('Spree::Order') }
  it { should have_many(:products).class_name('Spree::Product') }
  it { should have_many(:favorite_products).class_name('Spree::FavoriteProduct') }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:school_district) }

  it "has default user role" do
    expect(user.spree_roles.first).to eq(Spree::Role.user)
  end

  describe "#has_admin_role?" do
    it "return true for admin" do
      expect(admin_user.has_admin_role?).to eq(true)
    end
  end
end
