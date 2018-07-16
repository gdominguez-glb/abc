require 'inkling'

namespace :inkling do
  desc "List inkling files"
  task upload_exists: :environment do
    products = []
    user_ids = Spree::LicensedProduct.where(product_id: products.map(&:id)).available.pluck(:user_id)
    users = Spree::User.where(id: user_ids)
    users.each do |user|
      licenses = user.inkling_connect_licenses
      if licenses.present?
        Inkling.onboard(user, licenses)
      end
    end
  end
end
