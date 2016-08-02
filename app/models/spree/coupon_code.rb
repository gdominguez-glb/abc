class Spree::CouponCode < ActiveRecord::Base
  belongs_to :school_district

  has_and_belongs_to_many :products, class_name: 'Spree::Product', join_table: :spree_coupon_codes_products

  validates_presence_of :total_quantity

  before_validation :generate_code, on: :create

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
end
