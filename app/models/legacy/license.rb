class Legacy::License < ActiveRecord::Base

  belongs_to :user, class_name: 'Legacy::User', primary_key: :ee_id

  def self.import_to_new_licenses
    Legacy::License.where.not(email: nil).find_each do |legacy_license|
      product = Spree::Product.find_by(name: legacy_license.mapped_name)
      licensed_product = Spree::LicensedProduct.create(
        email:          legacy_license.email,
        expire_at:      legacy_license.expiration_date,
        product:        product,
        quantity:       1,
        fulfillment_at: Time.now,
        skip_salesforce_create: true,
        skip_notification: true
      )
      import_distribution(legacy_license, licensed_product)
    end
  end

  def self.import_distribution(legacy_license, licensed_product)
    return if legacy_license.email == legacy_license.from_email
    distribution = Spree::ProductDistribution.create(
      from_email: legacy_license.from_email,
      email:      legacy_license.email,
      product:    licensed_product.product,
      expire_at:  licensed_product.expire_at,
      skip_salesforce_create: true
    )
    licensed_product.update(product_distribution: distribution, skip_next_salesforce_update: true)
  end


  def self.associate_licenses_to_distribution
    Spree::ProductDistribution.find_each do |distribution|
      licensed_product = Spree::LicensedProduct.find_by(product: distribution.product, email: distribution.from_email)
      if licensed_product
        quantity = Legacy::License.where(from_email: distribution.from_email, mapped_name: distribution.product.name).count
        distribution.update(quantity: quantity, licensed_product: licensed_product, skip_next_salesforce_update: true)
      end
    end
  end
end
