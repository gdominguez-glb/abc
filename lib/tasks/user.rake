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
end