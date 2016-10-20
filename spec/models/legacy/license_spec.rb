require 'rails_helper'

RSpec.describe Legacy::License, type: :model do
  let!(:product) { create(:product, name: 'Sample Product') }
  let!(:expiration_date) { Date.new(2016, 6, 29) }

  before(:each) do
    create(:legacy_license, email: 'john@example.com', from_email: 'author@example.com', mapped_name: 'Sample Product', expiration_date: expiration_date)
    create(:legacy_license, email: 'author@example.com', from_email: 'author@example.com', mapped_name: 'Sample Product', expiration_date: expiration_date)
  end

  describe ".import_to_new_licenses" do
    before(:each) do
      Legacy::License.import_to_new_licenses
    end

    it "import licenses from legacy" do
      licensed_product = Spree::LicensedProduct.all

      expect(licensed_product.count).to eq(2)
      expect(licensed_product.last.product).to eq(product)
      expect(licensed_product.last.expire_at.to_date).to eq(expiration_date)
      expect(licensed_product.last.quantity).to eq(1)
    end
  end

  describe ".import_distributions" do
    before(:each) do
      Legacy::License.import_to_new_licenses
      Legacy::License.import_distributions
    end

    it "create licenses from distribution" do
      product_distributions = Spree::ProductDistribution.all

      expect(product_distributions.count).to eq(2)
    end

    it "create a source licensed product" do
      expect(Spree::LicensedProduct.count).to eq(3)
    end
  end

  describe ".create_source_licensed_product" do
    before(:each) do
      Legacy::License.import_to_new_licenses
      @source_licensed_product = Legacy::License.create_source_licensed_product('author@example.com', product, expiration_date)
    end

    it "create source licensed product for distribution" do
      expect(@source_licensed_product.id).not_to be_nil
      expect(@source_licensed_product.quantity).to eq(0)
    end
  end
end
