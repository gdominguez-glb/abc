namespace :salesforce do

  desc 'Synchronize with Salesforce'
  task sync: :environment do
    classes = { 'Account' => SchoolDistrict,
                'Contact' => Spree::User,
                'PricebookEntry' => Spree::Product }
    classes.each do |name, klass|
      import_all = (klass == Spree::Product ? true : false)
      processed = SalesforceObjectImporter.new(name, klass).import(import_all)
      puts "#{processed} Salesforce #{name} records processed"
    end
  end

  desc 'Cleanup salesforce reference not exists in salesforce'
  task cleanup: :environment do
    client = GmSalesforce::Client.instance
    SalesforceReference.where(local_object_type: 'SchoolDistrict').find_each do |salesforce_reference|
      begin
        client.find('Account', salesforce_reference.id_in_salesforce)
      rescue Exception => e
        if e.message == "NOT_FOUND: The requested resource does not exist"
          salesforce_reference.local_object.destroy
        end
      end
    end
  end
end
