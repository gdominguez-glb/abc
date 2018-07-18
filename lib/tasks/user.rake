namespace :user do
  desc 'delete users by email'
  task delete: :environment do
    email = ENV['email']
    if email.present?
      user = Spree::User.find_by(email: email)
      if user.nil?
        puts "No user was found with the email: #{email}"
      else
        user.destroy!
        puts "User #{email} was successfully deleted"
      end
    else
      puts 'Please set an email in email='
    end
  end

  desc "Export users"
  task export: :environment do
    users_count = 0
    puts "Start to export users to excel: users_data.xlsx"
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Users") do |sheet|
        sheet.add_row ['Id', 'First Name', 'Last Name', 'Email', 'Roles']
        Spree::User.includes(:spree_roles).find_each do |user|
          sheet.add_row [user.id, user.first_name, user.last_name, user.email, user.spree_roles.map(&:name).map(&:titleize).join(', ')]

          users_count += 1
          if users_count % 100 == 0
            print '.'
          end

        end
      end
      p.serialize('users_data.xlsx')
      puts "Done."
    end
  end

  desc "Export user with products"
  task export_with_products: :environment do
    product_names = ENV['product_names'].split(',')
    products = Spree::Product.where('lower(internal_name) in (?)', product_names.map(&:downcase))
    user_ids = Spree::LicensedProduct.where(product_id: products.map(&:id)).pluck(:user_id).compact.uniq

    users_count = 0
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Users") do |sheet|
        sheet.add_row ['Id', 'First Name', 'Last Name', 'Email', 'Roles', 'School or District', 'Zip Code']

        Spree::User.includes(:spree_roles, :school_district).where(id: user_ids).find_each do |user|
          sheet.add_row [
            user.id,
            user.first_name,
            user.last_name,
            user.email,
            user.spree_roles.map(&:name).map(&:titleize).join(', '),
            user.school_district.try(:place_type),
            user.zip_code
          ]

          users_count += 1
          if users_count % 100 == 0
            print '.'
          end
        end

      end
      p.serialize('users_data.xlsx')
      puts "Done."
    end
  end
end
