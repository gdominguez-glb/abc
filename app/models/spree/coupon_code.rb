class Spree::CouponCode < ActiveRecord::Base
  belongs_to :school_district

  has_many :coupon_code_products, class_name: 'Spree::CouponCodeProduct'
  has_and_belongs_to_many :products, class_name: 'Spree::Product', join_table: :spree_coupon_codes_products

  before_validation :generate_code, on: :create

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
