class Spree::CouponCode < ActiveRecord::Base
  belongs_to :school_district

  has_many :coupon_code_products, class_name: 'Spree::CouponCodeProduct'
  has_many :products, -> { order("spree_coupon_codes_products.created_at asc") }, through: :coupon_code_products
  has_many :available_products, -> { where('spree_coupon_codes_products.used_quantity < spree_coupon_codes_products.quantity').order("spree_coupon_codes_products.created_at asc") }, through: :coupon_code_products, source: :product

  has_one :order, class_name: 'Spree::Order'

  validates_presence_of :code
  validates_uniqueness_of :code, if:  Proc.new { |cc| cc.code.present? }

  before_validation :generate_code, on: :create
  after_commit :generate_coupon_code_order, on: :create

  attr_accessor :schools_xls
  serialize :school_lists, Array

  def grades_to_select
    sql = <<-SQL
      select distinct(spree_grades.*) from spree_grades
        join spree_grades_products on spree_grades_products.grade_id = spree_grades.id
        join spree_coupon_codes_products on spree_coupon_codes_products.product_id = spree_grades_products.product_id
        where spree_coupon_codes_products.coupon_code_id = #{self.id}
    SQL
    Spree::Grade.find_by_sql(sql)
  end

  def available?
    if self.old_coupon_code?
      return (used_quantity || 0) < total_quantity
    else
      return self.available_products.count > 0
    end
  end

  def old_coupon_code?
    self.created_at < Date.new(2017, 8, 17)
  end

  def products_to_activate
    self.old_coupon_code? ? self.products : self.available_products
  end

  def products_of_grade(grade_id)
    sql = <<-SQL
      select distinct(spree_products.*) from spree_products
        join spree_grades_products on spree_grades_products.product_id = spree_products.id
        join spree_coupon_codes_products on spree_coupon_codes_products.product_id = spree_grades_products.product_id
        where spree_coupon_codes_products.coupon_code_id = #{self.id} and spree_grades_products.grade_id = #{grade_id}
    SQL
    Spree::Product.find_by_sql(sql)
  end

  def increase_used_quantity!
    self.used_quantity ||= 0
    self.used_quantity += 1
    self.save
  end

  private

  def generate_code
    if self.code.present?
      self.code = self.code.upcase
      return
    end
    self.code = nil
    max_length = 8
    self.code ||= loop do
      random = ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(max_length).join
      if Spree::CouponCode.where(code: random).exists?
        max_length += 1 if self.class.count > (10 ** max_length / 2)
      else
        break random
      end
    end
  end

  def generate_coupon_code_order
    return if self.order
    order = Spree::Order.new(
      coupon_code_id: self.id,
      source: :coupon_code_order,
      state: 'complete',
      school_district_id: self.school_district_id,
      email: 'web.admin@greatminds.net'
    )
    if self.sync_specified_order? && self.sf_order_id.present?
      order.build_salesforce_reference(id_in_salesforce: self.sf_order_id)
    end
    order.save
  end
end
