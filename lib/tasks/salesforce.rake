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
    sf_client = GmSalesforce::Client.instance.client
    deleted_response = sf_client.get_deleted('Account', 2.days.ago.beginning_of_day, Date.today.end_of_day)
    deleted_response.deletedRecords.each do |deleted_object|
      sr = SalesforceReference.find_by(id_in_salesforce: deleted_object.id)
      if sr && sr.local_object
        reassign_school_district_for_users(sf_client, sr.local_object)
      end
    end
  end

  def reassign_school_district_for_users(sf_client, school_district)
    Spree::User.where(school_district_id: school_district.id).find_each do |user|
      begin
        if user.id_in_salesforce.present?
          contact_sfo = sf_client.find('Contact', user.id_in_salesforce)
          new_school_district = SalesforceReference.find_by(id_in_salesforce: contact_sfo.AccountId).local_object
          user.update(school_district: new_school_district) if new_school_district
        end
      rescue
      end
    end
    if Spree::User.where(school_district_id: school_district.id).count == 0
      school_district.destroy
    end
  end
end
