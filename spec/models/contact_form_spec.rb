require 'rails_helper'

RSpec.describe ContactForm do

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:phone) }

  let(:contact_form) { ContactForm.new(first_name: 'A', last_name: 'B', email: 'a@b.com') }

  context "if requiere description" do
    before { allow(subject).to receive(:require_description?).and_return(true) }
    it { should validate_presence_of(:description) }
  end

  context "if doesn't requiere description" do
    before { allow(subject).to receive(:require_description?).and_return(false) }
    it { should_not validate_presence_of(:description) }
  end

  describe "#perform" do
    it "create lead with 'Sales/Purchasing', 'Professional Development'" do
      ['Sales/Purchasing', 'Professional Development'].each do |topic|
        contact_form.topic = topic
        expect(contact_form).to receive(:create_lead_object)
        contact_form.perform
      end
    end

    it 'create case with "Existing Order Support", "Curriculum Support", "Technical Support", "Parent Support", "Content Error", "General and Other"' do
      ["Existing Order Support", "Curriculum Support", "Technical Support", "Parent Support", "Content Error", "General and Other"].each do |topic|
        contact_form.topic = topic
        expect(contact_form).to receive(:create_case_object)
        contact_form.perform
      end
    end
  end

  describe "#lead_common_attributes" do
    it "include specify common attributes for leads" do
      expect(contact_form.lead_common_attributes.keys.sort).to eq(["Company", "Curriculum__c", "Email", "FirstName", "LastName", "Phone", "Title", "Type__c"])
    end
  end

  describe "#case_common_attributes" do
    it "include specify common attributes for cases" do
      expect(contact_form.case_common_attributes.keys.sort).to eq(["Curriculum__c", "Email__c", "First_Name__c", "General_Details__c", "General__c", "Last_Name__c", "Phone__c", "Role__c", "School_District_Name__c", "School_District__c"])
    end
  end

  describe "#general_attributes" do
    it "include specify general attributes" do
      expect(contact_form.general_attributes.keys.sort).to eq(["Description", "Origin", "Priority", "State__c", "Subject", "status"])
    end
  end

  describe "#sales_attributes" do
    it "include specify sales attributes" do
      expect(contact_form.sales_attributes.keys.sort).to eq(["Country", "Curriculum__c", "Description", "LeadSource", "Returning_Customer__c", "State", "Title_1__c"])
    end
  end

  describe "#pd_attributes" do
    it "include specify pd attributes" do
      allow(contact_form).to receive(:lead_pd_request_record_type_id).and_return('')
      allow(contact_form).to receive(:pd_lead_queue_id).and_return('')

      expect(contact_form.pd_attributes.keys.sort).to eq(["Comments__c", "Country", "Curriculum__c", "Description", "Desired_Training_City__c", "Grade_Training_Request__c", "Interested_in_hosting_an_open_enrollment__c", "OwnerId", "RecordTypeId", "Request_Date__c", "Session_Preference__c", "Size_of_Training_Groups__c", "State", "X1st_Date_Preference__c"])
    end
  end

  describe "#support_attributes" do
    it "include specify support attributes" do
      expect(contact_form.support_attributes.keys.sort).to eq(["Description", "Origin", "Priority", "Related_Grade_Module_Unit_Lesson__c", "State__c", "Status", "Subject"])
    end

    it "include specify Existing Order Support attributes" do
      contact_form.topic = 'Existing Order Support'
      expect(contact_form.support_type_attributes.keys.sort).to eq(["Curriculum__c", "Items_Purchased__c"])
    end

    it "include specify attributes for 'Parent Support', 'Technical Support', 'Content Error'" do
      ['Parent Support', 'Technical Support', 'Content Error'].each do |topic|
        contact_form.topic = topic
        expect(contact_form.support_type_attributes.keys.sort).to eq(["Curriculum__c", "Description"])
      end
    end
  end

  describe "#lead_pd_request_record_type_id" do
    it "find record type id from Lead PD Request" do
      allow(RecordType).to receive(:find_in_salesforce_by_name_and_object_type).with('PD Request', 'Lead').and_return(Hashie::Mash.new({'Id' => '123'}))
      expect(contact_form.lead_pd_request_record_type_id).to eq('123')
    end
  end

  describe "#save_contact_record" do
    it "create new contact with sf attributes" do
      contact_form.topic = 'Curriculum Support'
      contact = contact_form.save_contact_record({})

      expect(contact.persisted?).to eq(true)
    end
  end
end
