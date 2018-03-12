namespace :salesforce do

  desc 'Synchronize with Salesforce'
  task sync: :environment do
    return if !Spree::Config[:salesforce_enabled]

    classes = { 'Account' => SchoolDistrict,
                'Contact' => Spree::User,
                'PricebookEntry' => Spree::Product }
    import_all = false
    classes.each do |name, klass|
      processed = SalesforceObjectImporter.new(name, klass).import(import_all)
      puts "#{processed} Salesforce #{name} records processed"
    end
  end

  desc 'Cleanup salesforce reference not exists in salesforce'
  task cleanup: :environment do
    return if !Spree::Config[:salesforce_enabled]

    sf_client = GmSalesforce::Client.instance.client

    cleanup_deleted_accounts(sf_client)
    cleanup_deleted_contacts(sf_client)
  end

  def cleanup_deleted_accounts(sf_client)
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

  def cleanup_deleted_contacts(sf_client)
    deleted_response = sf_client.get_deleted('Contact', 29.days.ago.beginning_of_day, Date.today.end_of_day)

    salesforce_references = deleted_response.deletedRecords.map { |deleted_object| SalesforceReference.find_by(id_in_salesforce: deleted_object.id) }.compact

    salesforce_references.each do |salesforce_reference|
      result = sf_client.query("select Id from Contact where Web_Front_End_ID__c = '#{sr.local_object.id}'").first
      if result && result.Id.present?
        salesforce_reference.update(id_in_salesforce: result.Id)
      end
    end
  end

end
