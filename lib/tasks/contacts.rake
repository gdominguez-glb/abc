namespace :contacts do

  desc "Send sales contacts excels"
  task send_sales_contacts: :environment do
    current_time = Time.now.in_time_zone('Eastern Time (US & Canada)')
    past_hours = current_time.hour == 10 ? 24 : 6
    contacts = Contact.where('created_at > ?', past_hours.hours.ago).select { |contact| contact.message && contact.message.keys.include?('LeadSource') }
    file_name = "lead_contacts_#{Time.now.to_i}.xlsx"

    return if contacts.blank?

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Lead Contacts") do |sheet|
        sheet.add_row [
          "FirstName", "LastName", "Role", "Email", "Phone", "School/District", "School District Name", "Curriculum",
          "Street", "Country", "State", "Title_1", "Returning Customer", "Description", "Lead Source", "PostalCode",
          "RecordTypeId", "OwnerId", "Comments__c", "CreatedAt"]
        contacts.each do |contact|
          m = contact.message
          sheet.add_row [
            m['FirstName'], m['LastName'], m['Title'], m['Email'], m['Phone'], (m['Type__c'] || m['School_or_District__c']), (m['Company'] || m['School_District__c']), m['Curriculum__c'],
            m['Street'], m['Country'], m['State'], m['Title_1__c'], m['Returning_Customer__c'], m['Description'], m['LeadSource'], m['PostalCode'],
            m['RecordTypeId'], m['OwnerId'], m['Comments__c'], contact.created_at.strftime('%F %H:%M')
          ]
        end
      end
      p.serialize(file_name)
    end

    LeadContactMailer.notify(Rails.root.join(file_name)).deliver_now
  end

end
