class AssignLicensesForm
  include ActiveModel::Model

  attr_accessor :licenses_recipients, :product_id, :licenses_number, :total
  
  validates_presence_of :licenses_recipients, :product_id, :licenses_number
  
  def perform
  end
end
