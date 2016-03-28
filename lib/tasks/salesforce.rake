namespace :salesforce do
  desc 'Synchronize with Salesforce'
  task sync: :environment do
    classes = { 'Account' => SchoolDistrict,
                'Contact' => Spree::User,
                'PricebookEntry' => Spree::Product }
    classes.each do |name, clazz|
      processed = clazz.import_salesforce
      puts "#{processed} Salesforce #{name} records processed"
    end
  end
end
