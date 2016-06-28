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
        if e.message =~ /NOT_FOUND/
          reassign_school_district_for_users(sf_client, salesforce_reference.local_object)
          salesforce_reference.local_object.destroy
        end
      end
    end
  end

  def reassign_school_district_for_users(sf_client, school_district)
    Spree::User.where(school_district_id: school_district.id).find_each do |user|
      begin
        contact = sf_client.find('Contact', user.id_in_salesforce)
        new_school_district = SalesforceReference.find_by(id_in_salesforce: contact.AccountId).local_object
        user.update(school_district: new_school_district)
      rescue
      end
    end
  end
end
