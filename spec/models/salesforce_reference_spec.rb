require 'rails_helper'

RSpec.describe SalesforceReference, type: :model do
  it { should belong_to(:local_object) }

  let(:salesforce_reference) { create(:salesforce_reference) }

  describe "#object_from_properties" do
    it "return nil if properties is blank" do
      expect(salesforce_reference.object_from_properties({})).to eq(nil)
    end

    it "return mash with properties" do
      properties = salesforce_reference.object_from_properties({ 'a' => 123, 'b' => 321 })

      expect(properties.a).to eq(123)
    end
  end

  describe "#update_properties_from_object" do
    it "save properties" do
      salesforce_reference.update_properties_from_object({ 'a' => 123 })

      expect(salesforce_reference.reload.object_properties).to eq({ 'a' => 123 })
    end
  end
end
