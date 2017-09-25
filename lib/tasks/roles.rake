namespace :roles do
  desc "Generate new roles"
  task generate: :environment do
    ["account_sales"].each do |role|
      Spree::Role.find_or_create_by(name: role)
      puts "Role #{role} was successfully created"
    end
  end
end
