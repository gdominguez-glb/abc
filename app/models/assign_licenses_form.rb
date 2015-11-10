class AssignLicensesForm
  include ActiveModel::Model

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  attr_accessor :user, :licenses_recipients, :emails, :licenses_ids, :licenses_number, :total

  validate :emails_must_be_correct
  validate :must_have_enough_licenses_quantity

  validates_presence_of :licenses_recipients, :licenses_ids
  validates :licenses_number, presence: true, numericality: { greater_than: 0 }

  def perform
    licensed_products = @user.licensed_products.where(id: @licenses_ids)
    Spree::LicensesManager::LicensesDistributer.new(user: @user, licensed_products: licensed_products, rows: build_rows).execute
  end

  def build_rows
    all_emails.map do |email|
      { email: email, quantity: @licenses_number.to_i }
    end
  end

  def must_have_enough_licenses_quantity
    licenses_quantity = @user.licensed_products.where(id: @licenses_ids).sum(:quantity)
    if licenses_quantity < all_emails.count * @licenses_number.to_i
      self.errors.add(:licenses_number, "exceed your licenses quantity")
    end
  end

  def emails_must_be_correct
    all_emails.each do |email|
      if email !~ EMAIL_REGEX
        self.errors.add(:licenses_recipients, 'must include correct emails')
      end
    end
  end

  def all_emails
    @all_emails ||= (@licenses_recipients || '').split(',').map(&:strip) + (@emails||[])
  end
end
