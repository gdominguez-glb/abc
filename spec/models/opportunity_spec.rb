require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  let(:opportunity){ FactoryGirl.build(:opportunity) }

  before(:each){ opportunity.attachments.build(FactoryGirl.attributes_for(:opportunity_attachment)) }
  before(:each){ allow_any_instance_of(Opportunity).to receive(:salesforce_exists?).and_return(true) }

  it { should validate_presence_of :salesforce_id }

  describe "#salesforce_exists?" do
    it 'should mock method and return true' do
      expect(opportunity.valid?).to be_truthy
    end
  end

  describe "#has_attachments?" do
    context "should validate that the opportunity has at least one attachment" do
      it "#one_attachment" do
        expect(opportunity.valid?).to be_truthy
      end

      it "#no_attachment" do
        op = FactoryGirl.build(:opportunity)
        expect(op.valid?).to be_falsey
      end
    end
  end
end
