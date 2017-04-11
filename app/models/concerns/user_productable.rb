module UserProductable
  extend ActiveSupport::Concern

  included do
    has_many :completed_orders, -> { where.not(completed_at: nil) }, class_name: 'Spree::Order'
    has_many :licensed_products, -> { available }, class_name: 'Spree::LicensedProduct'
    has_many :managed_licensed_products, -> { unexpire.fulfillmentable }, class_name: 'Spree::LicensedProduct'
    has_many :products, -> { unexpire.where(spree_licensed_products: { can_be_distributed: false }).order('spree_licensed_products.id desc') }, through: :licensed_products, class_name: 'Spree::Product'
    has_many :dashboard_licensed_products, -> { unexpire }, class_name: 'Spree::LicensedProduct'
    has_many :products_in_dashboard, -> { unexpire.where(spree_licensed_products: { can_be_distributed: false }).where("spree_licensed_products.quantity > 0").order('spree_licensed_products.id desc') }, through: :dashboard_licensed_products, class_name: 'Spree::Product', source: :product
    has_many :product_distributions, foreign_key: :from_user_id, class_name: 'Spree::ProductDistribution'
    has_many :product_tracks
    has_many :product_agreements, class_name: 'Spree::ProductAgreement'
  end

  def part_products
    part_product_ids = licensed_products.
        joins("join spree_parts on spree_parts.bundle_id = spree_licensed_products.product_id").
        joins("join spree_products on spree_parts.product_id = spree_products.id").
        select("distinct(spree_products.id)").map(&:id)
    Spree::Product.where(id: part_product_ids)
  end

  def licensed_products_from(school_district_admin)
    Spree::LicensedProduct.where(user_id: self.id).joins(:product).joins(:product_distribution).where({spree_product_distributions: { from_user_id: school_district_admin.id }}).uniq
  end

  def assign_licenses
    Spree::LicensedProduct.assign_license_to(self, true)
  end

  def assign_distributions
    Spree::ProductDistribution.assign_distributions(self)
  end

  def managed_products
    @managed_products ||= begin
      product_ids = managed_licensed_products.pluck(:product_id) + product_distributions.pluck(:product_id)
      Spree::Product.where(id: product_ids).order("name asc")
    end
  end

  def managed_products_options
    managed_licensed_products.distributable.fulfillmentable.includes(:product).group_by { |lp| format_name_with_expire_date(lp) }.map do |key, licenses|
      [key, licenses.map(&:id).sort.join(',')]
    end
  end

  def format_name_with_expire_date(lp)
    "#{lp.product.name}#{' expiring ' + lp.expire_at.strftime("%B %Y") rescue nil}"
  end

  def purchased_licenses_count(licenses_ids)
    distributed_licenses_count(licenses_ids) + remaining_licenses_count(licenses_ids)
  end

  def distributed_licenses_count(licenses_ids)
    product_distributions.where(licensed_product_id: licenses_ids).sum(:quantity)
  end

  def remaining_licenses_count(licenses_ids)
    managed_licensed_products.distributable.where(id: licenses_ids).sum(:quantity)
  end

  def has_more_than_3_products?
    sql = <<-SQL
      select 1 from
        (
        select sum(quantity) as quantity_count from
          (
            ( select product_id, quantity from spree_licensed_products where user_id = #{self.id} )
            UNION
            ( select product_id, quantity from spree_product_distributions where from_user_id = #{self.id})
          ) a group by a.product_id
        ) b where b.quantity_count > 3
    SQL
    result = ActiveRecord::Base.connection.execute(sql)
    result.count > 0
  end

  def accessible_products
    @accessible_products ||= begin
      _product_ids = products.where("spree_licensed_products.quantity > 0").pluck(:id)
      _part_ids = Spree::Part.where(bundle_id: _product_ids).pluck(:product_id)
      Spree::Product.where(id: _product_ids+_part_ids)
    end
  end

  def my_resources
    top_activity_ids = self.activities.where(action: ['buy', 'launch_resource'], item_type: 'Spree::Product').select('distinct(activities.id) as id, updated_at').order('updated_at desc').map(&:id)
    top_activity_ids_conds = top_activity_ids.count > 0 ? "AND activities.id in (#{top_activity_ids.join(',')})" : ''
    accessible_products.select('spree_products.*, COALESCE(activities.updated_at, null) AS activities_update_at')
        .joins("LEFT JOIN activities ON (activities.item_id = spree_products.id AND action in ('buy', 'launch_resource') AND item_type = 'Spree::Product' AND user_id = #{self.id}) #{top_activity_ids_conds}")
        .where('spree_products.product_type != ?', 'bundle').order('activities_update_at DESC NULLS LAST')
  end

  def bought_free_trial_product?(product, exclude_order)
    product.purchase_once? && Spree::LicensedProduct.where(user_id: self.id, product_id: product.id).where.not(order_id: exclude_order.try(:id)).exists?
  end

  def update_log_activity_product(product)
    activity = Activity.find_or_create_by(user: self, title: 'Overview', item_id: product.id, item_type: 'Spree::Product', action: :launch_resource)
    activity.update(updated_at: Time.now)
  end

  def agree_term_of_product?(product)
    self.product_agreements.where(product: product).exists?
  end

  def has_active_license_on?(product)
    licensed_products.where(product_id: product.id).exists?
  end
end
