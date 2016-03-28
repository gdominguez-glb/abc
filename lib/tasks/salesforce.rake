namespace :salesforce do

  desc 'Synchronize with Salesforce'
  task sync: :environment do
    classes = { 'Account' => SchoolDistrict,
                'Contact' => Spree::User,
                'PricebookEntry' => Spree::Product }
    classes.each do |name, klass|
      processed = SalesforceObjectImporter.new(name, klass).import
      puts "#{processed} Salesforce #{name} records processed"
    end
  end
end
