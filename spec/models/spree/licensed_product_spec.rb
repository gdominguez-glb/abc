require 'rails_helper'

RSpec.describe Spree::LicensedProduct, type: :model do
  describe "#distribute_license" do
    let(:licensed_product) { create(:spree_licensed_product) }
    let(:to_user) { create(:user, email: 'john123@doe.com', first_name: 'John', last_name: 'Doe', school_district: create(:school_district) ) }

    it "distribute license to user" do
      distribution = licensed_product.distribute_license(to_user)
      expect(distribution.to_user).to eq(to_user)
    end

    it "distribute license to email" do
      distribution = licensed_product.distribute_license('john@doe.com')
      expect(distribution.email).to eq('john@doe.com')
    end
  end
end
