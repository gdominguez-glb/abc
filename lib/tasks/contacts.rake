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

  desc "Sync contacts data to salesforce"
  task sync_to_salesforce: :environment do
    # 10 am EST on March 18th and turned it on at 515 pm EST on March 21st.
    Time.zone = 'Eastern Time (US & Canada)'
    from_time = Time.zone.parse('2018-03-18 10:00:00 am')
    to_time   = Time.zone.parse('2018-03-21 05:15 pm')

    Contact.where('created_at between ? and ?', from_time, to_time).each do |contact|
      if ['Sales/Purchasing', 'Professional Development'].include?(contact.topic)
        ContactWorker.new.perform('Lead', contact.message)
      elsif ["Existing Order Support", "Curriculum Support", "Technical Support", "Parent Support", "Content Error", "General and Other"].include?(contact.topic)
        ContactWorker.new.perform('Case', contact.message)
      end
    end
  end
end
