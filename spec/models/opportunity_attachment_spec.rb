require 'rails_helper'

RSpec.describe OpportunityAttachment, type: :model do
  it { should have_attached_file :file }
  it { should validate_attachment_presence :file }

  describe "#sobject_name" do
    it 'should return the salesforce object name' do
      expect(OpportunityAttachment.sobject_name).to eq('Attachment')
    end
  end
end
