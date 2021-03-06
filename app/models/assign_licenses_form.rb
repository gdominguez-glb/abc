class AssignLicensesForm
  include ActiveModel::Model

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  attr_accessor :user, :licenses_recipients, :emails, :licenses_ids, :licenses_number, :total

  validate :emails_must_be_correct
  validate :must_have_enough_licenses_quantity

  validates_presence_of :licenses_recipients, :licenses_ids
  validates :licenses_number, presence: true, numericality: { greater_than: 0 }

  def perform
    LicensesDistributionWorker.perform_async(@user.id, all_licenses_ids, all_emails, @licenses_number)
  end

  def build_rows
    all_emails.map do |email|
      { email: email, quantity: @licenses_number.to_i }
    end
  end

  def must_have_enough_licenses_quantity
    licenses_quantity = @user.licensed_products.where(id: all_licenses_ids).sum(:quantity)
    if licenses_quantity < all_emails.count * @licenses_number.to_i
      self.errors.add(:licenses_number, "exceed your licenses quantity")
    end
  end

  def emails_must_be_correct
    error_emails = all_emails.select { |email| email !~ EMAIL_REGEX }
    if error_emails.present?
      self.errors.add(:licenses_recipients, "must include correct emails. (Incorrect email: #{error_emails.join(', ')})")
    end
  end

  def all_emails
    @all_emails ||= (@licenses_recipients || '').split(',').map(&:strip).map(&:downcase) + (@emails||[])
  end

  def all_licenses_ids
    return @licenses_ids if @licenses_ids.is_a?(Array)
    (@licenses_ids || '').split(',')
  end
end
