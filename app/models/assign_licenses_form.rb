class AssignLicensesForm
  include ActiveModel::Model

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  attr_accessor :user, :licenses_recipients, :product_id, :licenses_number, :total

  validate :emails_must_be_correct
  validate :must_have_enough_licenses_quantity

  validates_presence_of :licenses_recipients, :product_id
  validates :licenses_number, presence: true, numericality: { greater_than: 0 }

  def perform
    licensed_products = @user.licensed_products.where(product_id: @product_id).to_a
    emails.each do |email|
      user_or_email = Spree::User.find_by(email: email) || email
      current_licenses_number = @licenses_number.to_i
      licensed_products.each do |licensed_product|
        if licensed_product.quantity >= current_licenses_number
          licensed_product.distribute_license(user_or_email, current_licenses_number)
          break
        else
          current_licenses_number -= licensed_product.quantity
          licensed_product.distribute_license(user_or_email, licensed_product.quantity)
        end
      end
    end
  end

  def must_have_enough_licenses_quantity
    licenses_quantity = @user.licensed_products.where(product_id: @product_id).sum(:quantity)
    if licenses_quantity < emails.count * @licenses_number.to_i
      self.errors.add(:licenses_number, "exceed your licenses quantity")
    end
  end

  def emails_must_be_correct
    emails.each do |email|
      if email !~ EMAIL_REGEX
        self.errors.add(:licenses_recipients, 'must include correct emails')
      end
    end
  end

  def emails
    @emails ||= (@licenses_recipients || '').split(',').map(&:strip)
  end
end
