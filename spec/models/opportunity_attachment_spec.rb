require 'rails_helper'

RSpec.describe OpportunityAttachment, type: :model do
  let(:opportunity) { FactoryBot.create(:opportunity_with_attachment) }

  it { should have_attached_file :file }
  it { should validate_attachment_presence :file }

  before(:each){ allow_any_instance_of(OpportunityAttachment).to receive(:skip_salesforce_sync?).and_return(true) }
  before(:each){ allow_any_instance_of(GmSalesforce::Client).to receive(:find).and_return(true) }
  before(:each){ allow_any_instance_of(GmSalesforce::Client).to receive(:update).and_return(true) }
  before(:each){ allow_any_instance_of(GmSalesforce::Client).to receive(:query).and_return([Struct.new(:Opp_Id__c).new("00618000004YYXdAAO")]) }
  before(:each){ allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true) }
  before(:each){ allow_any_instance_of(Kernel).to receive(:open).and_return("http://falsy") }

  describe "#sobject_name" do
    it 'should return the salesforce object name' do
      expect(OpportunityAttachment.sobject_name).to eq('Attachment')
    end
  end

  describe "#attributes_for_salesforce" do
    it 'should return the hash for salesforce' do
      attachment = opportunity.attachments.first
      expect(attachment.attributes_for_salesforce).to eq({
       'ParentId' => attachment.opportunity.opportunity_id_sf,
       'Name' => attachment.file.original_filename,
       'Description' => attachment.file.original_filename,
       'Body' => Base64::encode64(open(attachment.file.url){|f| f.read})
     })
    end
  end
end
