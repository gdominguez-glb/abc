namespace :data do
  desc "create new training type category"
  task training_type_category: :environment do
    default_category = TrainingTypeCategory.create(title: 'Professional Development Sessions', is_default: true)
    EventTraining.update_all(training_type_category_id: default_category.id)
  end

  desc 'migrate document tags'
  task document_tags: :environment do
    ActsAsTaggableOn::Tagging.where(taggable_type: 'Document').find_each do |tagging|
      document = tagging.taggable
      if document
        new_tag_list = document.tags.map(&:name) + [tagging.tag.name]
        document.update(tag_list: new_tag_list.join(','))
      end
    end
  end

  desc "clear users data"
  task clear: :environment do
    SchoolDistrict.delete_all
    NotificationTrigger.delete_all
    Notification.delete_all
    ProductTrack.delete_all

    Spree::User.delete_all
    Spree::Product.delete_all
    Spree::Variant.delete_all
    Spree::ProductAgreement.delete_all
    Spree::ProductDistribution.delete_all
    Spree::Address.delete_all
    Spree::Bookmark.delete_all
    Spree::CreditCard.delete_all
    Spree::Digital.delete_all
    Spree::DigitalLink.delete_all
    Spree::Grade.delete_all
    Spree::GradeUnit.delete_all
    Spree::InklingCode.delete_all
    Spree::InventoryUnit.delete_all
    Spree::LicensedProduct.delete_all
    Spree::LineItem.delete_all
    Spree::LogEntry.delete_all
    Spree::MaterialFile.delete_all
    Spree::MaterialImportJob.delete_all
    Spree::Material.delete_all
    Spree::Order.delete_all
    Spree::Part.delete_all
    Spree::PaymentCaptureEvent.delete_all
    Spree::Payment.delete_all
    Spree::Price.delete_all
    ActiveRecord::Base.connection.execute("delete from spree_products_taxons")
    Spree::PurchaseOrder.delete_all
    Spree::Shipment.delete_all
    ActiveRecord::Base.connection.execute("delete from spree_taxons_videos")
    Spree::VideoGroup.delete_all
    Spree::Video.delete_all

    SalesforceReference.delete_all

    Activity.delete_all

    create_web_admin_account
  end

  def create_web_admin_account
    school_district = SchoolDistrict.where(
      name: 'Web Admin').first_or_create(
        place_type: SchoolDistrict.place_types[:unaffiliated],
        skip_salesforce_create: true)
      admin = Spree::User.new(
        first_name: 'Web',
        last_name: 'Admin',
        email: 'web.admin@greatminds.net',
        password: 'intridea4gm',
        password_confirmation: 'intridea4gm',
        school_district: school_district,
        skip_salesforce_create: true
      )
      role = Spree::Role.find_or_create_by(name: 'admin')
      admin.spree_roles << role
      admin.save
      admin.generate_spree_api_key!
  end

  desc "Export contacts with sf leads"
  task export_leads_contact: :environment do
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Lead Contacts") do |sheet|
        sheet.add_row [
          "FirstName", "LastName", "Role", "Email", "Phone", "School/District", "School District Name", "Curriculum",
          "Street", "Country", "State", "Title_1", "Returning Customer", "Description", "Lead Source", "PostalCode",
          "Session_Preference__c", "Desired_Training_City__c", "X1st_Date_Preference__c", "Grade_Training_Request__c",
          "Size_of_Training_Groups__c", "Interested_in_hosting_an_open_enrollment__c", "Request_Date__c",
          "RecordTypeId", "OwnerId", "Comments__c", "CreatedAt"]
        Contact.find_each do |contact|
          if contact.message && contact.message.keys.include?('Email') # only lead has Email column
            m = contact.message
            sheet.add_row [
              m['FirstName'], m['LastName'], m['Title'], m['Email'], m['Phone'], (m['Type__c'] || m['School_or_District__c']), (m['Company'] || m['School_District__c']), m['Curriculum__c'],
              m['Street'], m['Country'], m['State'], m['Title_1__c'], m['Returning_Customer__c'], m['Description'], m['LeadSource'], m['PostalCode'],
              m['Session_Preference__c'], m['Desired_Training_City__c'], m['X1st_Date_Preference__c'], m['Grade_Training_Request__c'],
              m['Size_of_Training_Groups__c'], m['Interested_in_hosting_an_open_enrollment__c'], m['Request_Date__c'],
              m['RecordTypeId'], m['OwnerId'], m['Comments__c'], contact.created_at.strftime('%F %H:%M')
            ]
          end
        end
      end
      p.serialize('lead_contacts.xlsx')
    end
  end

  desc "Export salesforce fields"
  task export_salesforce_fields: :environment do
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Salesforce field mapping") do |sheet|
        [Spree::LicensedProduct, Spree::Order, Spree::LineItem, Spree::User, SchoolDistrict].each do |klass|
          sheet.add_row [klass.name]
          sheet.add_row (klass.last || klass.new).attributes_for_salesforce.keys
          sheet.add_row []
          sheet.add_row []
        end
      end
      p.serialize('salesforce_fields_mapping.xlsx')
    end
  end
end
