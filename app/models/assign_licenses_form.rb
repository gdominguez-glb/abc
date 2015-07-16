class AssignLicensesForm
  include ActiveModel::Model

  LICENSES_NUMBER_OPTIONS = [
    ['1 License each user', 1],
    ['2 Licenses each user', 2],
    ['3 Licenses each user', 3],
  ]

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  attr_accessor :user, :licenses_recipients, :product_id, :licenses_number, :total
  
  validate :emails_must_be_correct
  validate :must_have_enough_licenses_quantity

  validates_presence_of :licenses_recipients, :product_id, :licenses_number
  
  def perform
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
