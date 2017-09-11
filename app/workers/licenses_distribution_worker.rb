class LicensesDistributionWorker
  include Sidekiq::Worker

  sidekiq_options queue: :licenses

  def perform(user_id, all_licenses_ids, all_emails, licenses_number)
    user = Spree::User.find(user_id)
    licensed_products = user.licensed_products.where(id: all_licenses_ids)
    rows = all_emails.map do |email|
      { email: email, quantity: licenses_number.to_i }
    end

    Spree::LicensesManager::LicensesDistributer.new(user: user, licensed_products: licensed_products, rows: rows).execute
  end

end
