namespace :legacy do
  desc "cleanup legacy users"
  task cleanup: :environment do
    emails = ENV['emails'].split(',').map(&:strip).map(&:downcase)
    raise 'please specify emails to cleanup' if emails.blank?
    Legacy::User.delete_all
    Legacy::License.delete_all

    Spree::User.unscoped.where(email: emails).delete_all
    Spree::LicensedProduct.unscoped.where(email: emails).delete_all
    Spree::ProductDistribution.unscoped.where(from_email: emails).delete_all
    Spree::ProductDistribution.unscoped.where(email: emails).delete_all
  end

  desc "import users/licenses from web 1.0"
  task import: :environment do
    emails = ENV['emails'].split(',').map(&:strip)

    puts 'importing all users' if emails.blank?

    Importers::User.import(emails)

    Importers::SchoolAdmin.import_sub_admins

    Importers::Licenses.import(emails)
    Importers::Licenses.import_user_email
  end

  desc "change user emails to example.com"
  task change_email: :environment do
    Legacy::User.find_each do |user|
      user.email = user.email.split('@').first + '@example.com'
      user.save
    end
    Legacy::License.find_each do |license|
      license.email = license.email.split('@').first + '@example.com' if license.email
      license.from_email = license.from_email.split('@').first + '@example.com' if license.from_email
      license.save
    end
  end

  desc "import legacy licenses"
  task import_licenses: :environment do
    Legacy::License.import_to_new_licenses
    Legacy::License.import_distributions
  end
end
