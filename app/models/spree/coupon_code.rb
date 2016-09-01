class Spree::CouponCode < ActiveRecord::Base
  belongs_to :school_district

  has_many :coupon_code_products, class_name: 'Spree::CouponCodeProduct'
  has_many :products, -> { order("spree_coupon_codes_products.created_at asc") }, through: :coupon_code_products

  has_one :order, class_name: 'Spree::Order'

  validates_presence_of :total_quantity, :code
  validates_uniqueness_of :code, if:  Proc.new { |cc| cc.code.present? }

  before_validation :generate_code, on: :create
  after_commit :generate_coupon_code_order, on: :create

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
    (used_quantity || 0) < total_quantity
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
    Spree::Order.create(coupon_code_id: self.id, source: :coupon_code_order, state: 'complete', school_district_id: self.school_district_id, email: 'web.admin@greatminds.net')
  end
end
