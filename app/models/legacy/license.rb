class Legacy::License < ApplicationRecord

  belongs_to :user, class_name: 'Legacy::User', primary_key: :ee_id

  def self.import_to_new_licenses
    Legacy::License.where(is_migrated: false).where.not(email: nil).find_each do |legacy_license|
      next if legacy_license.mapped_name.blank?
      product = Spree::Product.find_by(name: legacy_license.mapped_name)
      next if product.blank?
      licensed_product = Spree::LicensedProduct.create(
        email:          legacy_license.email,
        expire_at:      revise_expiration_date(product, legacy_license.expiration_date),
        lifetime_product: is_lifetime_product?(product),
        product:        product,
        quantity:       1,
        fulfillment_at: Time.now,
        skip_salesforce_create: true,
        skip_notification: true
      )
    end
  end

  def self.import_distributions
    licenses = Legacy::License.find_by_sql("select from_email, mapped_name, expiration_date from (select from_email, mapped_name, expiration_date, count(*) as q_count from legacy_licenses where is_migrated = 'f' group by mapped_name, from_email, expiration_date) a where a.q_count > 0")
    licenses.each do |license|
      from_email, product = license.from_email, Spree::Product.find_by(name: license.mapped_name)
      next if product.nil?
      import_distrbutions_for_product(from_email, product, license.expiration_date)
    end
  end

  def self.import_distrbutions_for_product(from_email, product, expiration_date)
    emails = Legacy::License.where(is_migrated: false, from_email: from_email, mapped_name: product.name, expiration_date: expiration_date).pluck(:email)
    return if emails.length == 1 && emails[0] == from_email
    source_licensed_product = create_source_licensed_product(from_email, product, expiration_date)
    return if source_licensed_product.nil?
    Spree::LicensedProduct.where(product: product, email: emails.compact, expire_at: revise_expiration_date(product, expiration_date)).where.not(id: source_licensed_product.id).each do |licensed_product|
      import_distribution(source_licensed_product, licensed_product)
    end
  end

  def self.create_source_licensed_product(from_email, product, expiration_date)
    self_distributed_license = Spree::LicensedProduct.find_by(email: from_email, product: product, expire_at: expiration_date)
    licenses_scope = Legacy::License.where(is_migrated: false, from_email: from_email, mapped_name: product.name, expiration_date: expiration_date)
    total_quantity = licenses_scope.where(email: nil).count
    Spree::LicensedProduct.create(
      product:        product,
      expire_at:      revise_expiration_date(product, expiration_date),
      lifetime_product: is_lifetime_product?(product),
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


  def self.revise_expiration_date(product, expiration_date)
    return nil if expiration_date.nil? || is_never_expire_product?(product)
    june_30 = Date.new(2016, 6, 30)
    (expiration_date <= june_30) ? expiration_date : Date.new(2017, 6, 30)
  end

  def self.is_lifetime_product?(product)
    LIFETIME_PRODUCT_NAMES.include?(product.name) || is_never_expire_product?(product)
  end

  def self.is_never_expire_product?(product)
    NEVER_EXPIRE_PRODUCT_NAMES.include?(product.name)
  end

  LIFETIME_PRODUCT_NAMES = [
    'Wheatley English Maps (Grades K-2)',
    'Wheatley English Maps (Grades 3-5)',
    'Wheatley English Maps (Grades 6-8)',
    'Wheatley English Maps (Grades 9-12)',
    'Wheatley English Maps (Grades K-12)',
    'Alexandria Plan Lower Elementary',
    'Alexandria Plan Upper Elementary'
  ]

  NEVER_EXPIRE_PRODUCT_NAMES = [
    'Basic Curriculum Files'
  ]
end
