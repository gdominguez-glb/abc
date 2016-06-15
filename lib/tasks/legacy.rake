namespace :legacy do
  desc "cleanup legacy users"
  task cleanup: :environment do
    emails = ENV['emails'].split(',').map(&:strip).map(&:downcase) rescue nil
    if emails.blank?
      emails = (Legacy::User.pluck(:email) + Legacy::License.pluck(:email)).uniq
    end
    Legacy::User.delete_all
    Legacy::License.delete_all

    Spree::User.unscoped.where(email: emails).delete_all
    Spree::LicensedProduct.unscoped.where(email: emails).delete_all
    Spree::ProductDistribution.unscoped.where(from_email: emails).delete_all
    Spree::ProductDistribution.unscoped.where(email: emails).delete_all
  end

  desc "import users/licenses from web 1.0"
  task import: :environment do
    emails = ENV['emails'].split(',').map(&:strip) rescue nil

    puts 'importing all users' if emails.blank?

    Importers::User.import(emails)

    Importers::Licenses.import(emails)
    Importers::Licenses.import_user_email

    Importers::SchoolAdmin.import
    Importers::SchoolAdmin.import_sub_admins
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

  desc "send migration emails"
  task send_notification: :environment do
    Legacy::User.find_each do |legacy_user|
      MigrationMailer.notify(
        email: legacy_user.email,
        first_name: legacy_user.first_name,
        last_name: legacy_user.last_name
      ).deliver_later
    end
  end
end
