# run from cron/whenever
class LicenseReminderWorker
  def perform
    notify_user(30)
    notify_user(15)

    notify_distributer(30)
    notify_distributer(15)
  end

  def notify_user(days)
    Spree::LicensedProduct.
      where("date(expire_at) = ?", days.days.since.to_date).
      group('user_id, product_id').select(:user_id, :product_id).
      group_by(&:user_id).each do |user_id, licensed_products|
        user = Spree::User.find(user_id)
        LicenseReminderMailer.remind({ user: user, products: licensed_products.map(&:product).uniq, days: 30 })
    end
  end

  def notify_distributer(days)
    distribution_ids = Spree::LicensedProduct.
      where("date(expire_at) = ?", days.days.since.to_date).
      where.not(product_distribution_id: nil).pluck(:product_distribution_id)
    Spree::ProductDistribution.
      where(id: distribution_ids).
      select(:from_user_id, :product_id).
      group(:from_user_id, :product_id).group_by(&:from_user_id).each do |from_user_id, distributions|
        user = Spree::User.find(user_id)
        LicenseReminderMailer.remind({ user: user, products: distributions.map(&:product).uniq, days: 30, is_district_admin: true })
    end
  end
end
