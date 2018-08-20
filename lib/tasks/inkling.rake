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

  desc "Import inkling ids for products"
  task import_inkling_ids: :environment do
    file = ENV['file']
    raise "Missing file" if file.blank?

    xlsx = Roo::Spreadsheet.open(file)
    xlsx.sheet(0).each(internal_name: 'INTERNAL NAME', inkling_id: 'FINAL INKLING ID') do |row|
      next if row[:internal_name].blank? || row[:internal_name] == 'INTERNAL NAME'
      product = Spree::Product.find_by(internal_name: row[:internal_name])

      if product.nil?
        puts "Can't find product with internal name: #{row[:internal_name]}"
        next
      end

      if ENV['check'].present?
        next
      end

      product.update!(inkling_id: row[:inkling_id], product_type: 'inkling_connect')
      puts "Update product: #{product.internal_name} inkling_id: #{row[:inkling_id]}"
    end
  end
end
