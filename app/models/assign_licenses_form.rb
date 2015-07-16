class AssignLicensesForm
  include ActiveModel::Model

  LICENSES_NUMBER_OPTIONS = [
    ['1 License each user', 1],
    ['2 Licenses each user', 2],
    ['3 Licenses each user', 3],
  ]

  attr_accessor :licenses_recipients, :product_id, :licenses_number, :total
  
  def initialize
    @total = 0
  end

  validates_presence_of :licenses_recipients, :product_id, :licenses_number
  
  def perform
  end
end
