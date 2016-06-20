require 'rails_helper'

RSpec.describe Spree::CsrAbility do

  let(:csr_user) { user = create(:gm_user); user.spree_roles << Spree::Role.csr; user }
  let(:ability) { Spree::CsrAbility.new(csr_user) }

  describe "csr allow to visit users and orders" do
    it "can manage users" do
      expect(ability.can?(:admin, Spree::User)).to eq(true)
      expect(ability.can?(:index, Spree::User)).to eq(true)
      expect(ability.can?(:read, Spree::User)).to eq(true)
      expect(ability.can?(:edit, Spree::User)).to eq(true)
    end

    it "can manage orders" do
      expect(ability.can?(:admin, Spree::Order)).to eq(true)
      expect(ability.can?(:index, Spree::Order)).to eq(true)
      expect(ability.can?(:read, Spree::Order)).to eq(true)
      expect(ability.can?(:edit, Spree::Order)).to eq(true)
    end
  end
end
