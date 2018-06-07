require 'process_helper'

namespace :salesforce do

  desc 'Synchronize with Salesforce'
  task sync: :environment do
    return if !Spree::Config[:salesforce_enabled]
    exist_pid = ProcessHelper.read_pid('salesforce.sync')
    next if exist_pid.present? && ProcessHelper.pid_still_running?(exist_pid)
    ProcessHelper.write_pid('salesforce.sync', Process.pid)

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

  desc "Resync school_districts/users/orders/licenses after salesforce back"
  task resync_salesforce: :environment do
    if !Spree::Config[:salesforce_enabled]
      puts "Salesforce is still disabled"
      return
    end

    time_point = ENV['start_time'].present? ? Time.parse(ENV['start_time']) : Time.parse('2018-03-18 00:00:00')

    SchoolDistrict.where('created_at > ?', time_point).each do |school_district|
      if school_district.id_in_salesforce.blank?
        school_district.create_in_salesforce(nil, false)
      end
    end

    Spree::User.where('created_at > ?', time_point).each do |user|
      if user.id_in_salesforce.blank?
        user.create_in_salesforce(nil, false)
      end
    end

    Spree::Order.where('created_at > ?', time_point).each do |order|
      if order.completed? && order.id_in_salesforce.blank?
        order.create_in_salesforce(nil, false)
      end
    end

    Spree::LicensedProduct.where('created_at > ?', time_point).each do |licensed_product|
      if licensed_product.id_in_salesforce.blank?
        licensed_product.create_in_salesforce(nil, false)
      end
    end
  end
end
