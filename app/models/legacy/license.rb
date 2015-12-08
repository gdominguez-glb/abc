class Legacy::License < ActiveRecord::Base

  belongs_to :user, class_name: 'Legacy::User', primary_key: :ee_id

  def self.import_to_new_licenses
    Legacy::License.where.not(email: nil).find_each do |legacy_license|
      product = Spree::Product.find_by(name: legacy_license.mapped_name)
      licensed_product = Spree::LicensedProduct.create(
        email:          legacy_license.email,
        expire_at:      revise_expiration_date(product, legacy_license.expiration_date),
        product:        product,
        quantity:       1,
        fulfillment_at: Time.now,
        skip_salesforce_create: true,
        skip_notification: true
      )
    end
  end

  def self.import_distributions
    licenses = Legacy::License.find_by_sql("select from_email, mapped_name from (select from_email, mapped_name, count(*) as q_count from legacy_licenses group by mapped_name, from_email) a where a.q_count > 0")
    licenses.each do |license|
      from_email, product = license.from_email, Spree::Product.find_by(name: license.mapped_name)
      next if product.nil?
      import_distrbutions_for_product(from_email, product)
    end
  end

  def self.import_distrbutions_for_product(from_email, product)
    emails = Legacy::License.where(from_email: from_email, mapped_name: product.name).pluck(:email)
    return if emails.length == 1 && emails[0] == from_email
    source_licensed_product = create_source_licensed_product(from_email, product)
    return if source_licensed_product.nil?
    Spree::LicensedProduct.where(product: product, email: emails.compact).where.not(id: source_licensed_product.id).each do |licensed_product|
      import_distribution(source_licensed_product, licensed_product)
    end
  end

  def self.create_source_licensed_product(from_email, product)
    self_distributed_license = Spree::LicensedProduct.find_by(email: from_email, product: product)
    licenses_scope = Legacy::License.where(from_email: from_email, mapped_name: product.name)
    total_quantity = licenses_scope.where(email: nil).count
    expire_at = licenses_scope.first.expiration_date
    Spree::LicensedProduct.create(
      product:        product,
      expire_at:      expire_at,
      email:          from_email,
      quantity:       total_quantity,
      fulfillment_at: Time.now,
      can_be_distributed: true,
      skip_salesforce_create: true,
      skip_notification: true
    )
  end

  def self.import_distribution(source_licensed_product, licensed_product)
    distribution = Spree::ProductDistribution.create!(
      from_email: source_licensed_product.email,
      email:      licensed_product.email,
      product:    licensed_product.product,
      expire_at:  licensed_product.expire_at,
      licensed_product: source_licensed_product,
      quantity: 1
    )
    licensed_product.update(product_distribution: distribution, skip_next_salesforce_update: true)
  end


  def self.associate_licenses_to_distribution
    Spree::ProductDistribution.find_each do |distribution|
      licensed_product = Spree::LicensedProduct.find_by(product: distribution.product, email: distribution.from_email)
      if licensed_product
        quantity = Legacy::License.where(from_email: distribution.from_email, mapped_name: distribution.product.name).count
        distribution.update(quantity: quantity, licensed_product: licensed_product)
      end
    end
  end

  def self.revise_expiration_date(product, expiration_date)
    return nil if expiration_date.nil?
    june_30 = Date.new(2016, 6, 30)
    (expiration_date <= june_30) ? expiration_date : product.expiration_date
  end
end
