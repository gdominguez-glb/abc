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
        sheet.add_row ['Id', 'First Name', 'Last Name', 'Email', 'Type']
        Spree::User.find_each do |user|
          sheet.add_row [user.id, user.first_name, user.last_name, user.email, user.title]

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
