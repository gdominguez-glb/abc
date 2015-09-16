class AssignLicensesForm
  include ActiveModel::Model

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  attr_accessor :user, :licenses_recipients, :product_id, :licenses_number, :total

  validate :emails_must_be_correct
  validate :must_have_enough_licenses_quantity

  validates_presence_of :licenses_recipients, :product_id
  validates :licenses_number, presence: true, numericality: { greater_than: 0 }

  def perform
    product = Spree::Product.find(@product_id)
    Spree::LicensesManager::LicensesDistributer.new(user: @user, product: product, rows: build_rows).execute
  end

  def build_rows
    emails.map do |email|
      { email: email, quantity: @licenses_number.to_i }
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
