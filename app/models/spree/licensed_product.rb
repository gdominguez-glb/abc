class Spree::LicensedProduct < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :order, class_name: 'Spree::Order'
  belongs_to :user, class_name: 'Spree::User'

  scope :available, -> { where("expire_at > ?", Time.now) }

  validates_presence_of :product
  validates_numericality_of :quantity, :greater_than => 0

  before_create :set_expire_at

  def distribute_license(user_or_email, quantity=1)
    distribution_attrs = {
      licensed_product: self,
      from_user:        self.user,
      product:          self.product,
      quantity:         quantity
    }
    if user_or_email.is_a?(Spree::User)
      distribution_attrs[:to_user] = user_or_email
    else
      distribution_attrs[:email] = user_or_email
    end
    Spree::ProductDistribution.create(distribution_attrs)
  end

  class << self
    def import(file)
      xlsx = Roo::Excelx.new file.path
      sheet = xlsx.sheet(0)
      header = sheet.row(1)
      return false if header.map(&:downcase) != ['email', 'product_id', 'quantity']
      licensed_products = (2..sheet.last_row).map do |i|
        row = Hash[[header, sheet.row(i)].transpose]
        Spree::LicensedProduct.new(row)
      end
      return false if !licensed_products.all?{|lp| lp.valid? }
      licensed_products.each{|lp| lp.save }
      return true
    end
  end

  private

  def set_expire_at
    if self.product.license_length.present? && self.expire_at.blank?
      self.expire_at = product.license_length.days.since(Time.now)
    end
  end
end
