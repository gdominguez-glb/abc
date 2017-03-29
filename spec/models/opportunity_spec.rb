require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  let(:opportunity){ FactoryGirl.build(:opportunity) }
  let(:opportunity_with_attachment){ FactoryGirl.build(:opportunity_with_attachment) }

  before(:each){ allow_any_instance_of(GmSalesforce::Client).to receive(:find).and_return(true) }
  before(:each){ allow_any_instance_of(GmSalesforce::Client).to receive(:update).and_return(true) }
  before(:each){ allow_any_instance_of(GmSalesforce::Client).to receive(:query).and_return([Struct.new(:Opp_Id__c).new("00618000004YYXdAAO")]) }
  before(:each){ allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true) }

  it { should validate_presence_of :salesforce_id }
  it { should have_many :attachments }

  describe "#salesforce_exists?" do
    it 'should not allow invalid object if it doesnt exist in salesforce' do
      allow_any_instance_of(GmSalesforce::Client).to receive(:query).and_return([Struct.new(:Opp_Id__c).new(nil)])
      expect(opportunity_with_attachment.valid?).to be_falsey
    end

    it 'should allow valid object if it exists in salesforce' do
      expect(opportunity_with_attachment.valid?).to be_truthy
    end
  end

  describe "#validate_attachment" do
    it 'should not allow to save if opportunity doesnt have any attachment' do
      expect(opportunity.valid?).to be_falsey
    end

    it 'should allow to save objet if it has at lest one attachment' do
      expect(opportunity_with_attachment.valid?).to be_truthy
    end
  end
end
