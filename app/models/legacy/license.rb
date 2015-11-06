class Legacy::License < ActiveRecord::Base

  belongs_to :user, class_name: 'Legacy::User', primary_key: :ee_id

  def self.import_to_new_licenses
    Legacy::License.find_each do |legacy_license|
      product = Spree::Product.find_by(name: legacy_license.mapped_name)
      licensed_product = Spree::LicensedProduct.create(
        product: product,
        quantity: 1,
        email: legacy_license.email,
        expire_at: legacy_license.expiration_date,
        fulfillment_at: Time.now
      )
      if legacy_license.from_email.present? && legacy_license.from_email != legacy_license.email
        distribution = import_distribution(legacy_license, licensed_product)
        licensed_product.update(product_distribution: distribution)
      end
    end
  end

  def self.import_distribution(legacy_license, licensed_product)
    Spree::ProductDistribution.create(
      from_email: legacy_license.from_email,
      email: legacy_license.email,
      product: licensed_product.product,
      expire_at: licensed_product.expire_at
    )
  end


  def self.associate_licenses_to_distribution
    Spree::ProductDistribution.find_each do |distribution|
      licensed_product = Spree::LicensedProduct.find_by(product: distribution.product, email: distribution.from_email)
      if licensed_product
        quantity = Spree::LicensedProduct.where(product_distribution: distribution).count
        distribution.update(quantity: quantity, licensed_product: licensed_product)
      end
    end
  end
end
