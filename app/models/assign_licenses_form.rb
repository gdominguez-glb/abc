class AssignLicensesForm
  include ActiveModel::Model

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  attr_accessor :user, :licenses_recipients, :product_id, :licenses_number, :total

  validate :emails_must_be_correct
  validate :must_have_enough_licenses_quantity

  validates_presence_of :licenses_recipients, :product_id
  validates :licenses_number, presence: true, numericality: { greater_than: 0 }

  def perform
    licensed_product = @user.licensed_products.find_by(product_id: @product_id)
    if licensed_product
      emails.each do |email|
        user_or_email = Spree::User.find_by(email: email) || email
        licensed_product.distribute_license(user_or_email, @licenses_number)
      end
    end
  end

  def must_have_enough_licenses_quantity
    licenses_quantity = @user.licensed_products.find_by(product_id: @product_id).try(:quantity) || 0
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
