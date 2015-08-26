# run from cron/whenever
class LicenseReminderWorker
  def perform
    notify_user(30)
    notify_user(15)

    notify_distributer(30)
    notify_distributer(15)
  end

  def notify_user(days)
    licenses_group = expiring_licenses_group_in_days(days)
    licenses_group.each do |user_id, licensed_products|
      LicenseReminderMailer.remind({ user: Spree::User.find(user_id), products: licensed_products.map(&:product).uniq, days: days })
    end
  end

  def expiring_licenses_group_in_days(days)
    Spree::LicensedProduct.
      expire_in_days(days).
      group('user_id, product_id').select(:user_id, :product_id).
      group_by(&:user_id)
  end

  def notify_distributer(days)
    distribution_ids    = expiring_distribution_ids(days)
    distributions_group = user_distributions_group(distribution_ids)
    distributions_group.each do |from_user_id, distributions|
      LicenseReminderMailer.remind({ user: Spree::User.find(user_id), products: distributions.map(&:product).uniq, days: days, is_district_admin: true })
    end
  end

  def user_distributions_group(distribution_ids)
    Spree::ProductDistribution.
      where(id: distribution_ids).
      select(:from_user_id, :product_id).
      group(:from_user_id, :product_id).group_by(&:from_user_id)
  end

  def expiring_distribution_ids(days)
    Spree::LicensedProduct.
      expire_in_days(days).
      where.not(product_distribution_id: nil).pluck(:product_distribution_id)
  end
end
