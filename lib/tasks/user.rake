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

  require 'roo'
  desc "Import detroit users"
  task import_detroit_users: :environment do
    file = ENV['file']
    raise "Missing file" if file.blank?

    count = 0
    default_password = 'gmdetroit123'
    title = 'Teacher'
    role = Spree::Role.user
    state_name = 'Michigan'
    city = 'Detroit'
    subjects = Curriculum.visibles.pluck(:id)

    xlsx = Roo::Spreadsheet.open(file)
    xlsx.sheet(0).each(email: 'Email', first_name: 'First Name', last_name: 'Last Name', school: 'School', zipcode: 'Zipcode', role: 'Role', state: 'State', city: 'City') do |row|
      next if row[:email] == 'Email'

      school_district = SchoolDistrict.where(name: row[:school]).last
      raise "Missing school district for: #{row[:school]}"

      user = Spree::User.find_or_initialize_by(email: row[:email])
      if user.persisted?
        puts "User: #{user.email} exists. Skip to next"
        next
      end
      user.update!(
        title: title,
        spree_roles: [role],
        state: state_name,
        city: city,
        password: default_password,
        interested_subjects: subjects
      )
      if user.persisted?
        count += 1
      end
    end
    puts "Imported users: #{count}"
  end
end
