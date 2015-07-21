class RevokeLicensesForm
  include ActiveModel::Model

  LICENSES_NUMBER_OPTIONS = [
    ['1 License', 1],
    ['2 Licenses', 2],
    ['3 Licenses', 3],
  ]

  attr_accessor :user, :reason, :product_id, :licenses_number

  REASONS = [
    'Reason 1',
    'Reason 2',
    'Reason 3'
  ]

  validates_presence_of :product_id, :licenses_number

  validate :must_have_enough_licenses_number

  def perform
    if distribution
      distribution.revoke(@licenses_number.to_i)
    end
  end

  def must_have_enough_licenses_number
    if distribution && @licenses_number.to_i > distribution.quantity
      self.errors.add(:licenses_number, "exceed user's licenses count")
    end
  end

  def distribution
    @distribution ||= Spree::ProductDistribution.find_by(product_id: @product_id, to_user_id: user.id)
  end
end
