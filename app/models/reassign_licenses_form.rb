class ReassignLicensesForm < AssignLicensesForm
  attr_accessor :user, :licenses_recipients, :product_id, :licenses_number, :total

  def perform
    distribution = Spree::ProductDistribution.find_by(to_user_id: user.id, product_id: @product_id)
    if distribution
      emails.each do |email|
        user = Spree::User.find_by(email: email)
        distribution.reassign_to((user || email), @licenses_number.to_i)
      end
    end
  end
end
