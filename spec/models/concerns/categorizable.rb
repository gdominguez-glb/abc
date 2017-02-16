require 'rails_helper'

shared_examples_for "categorizable" do
  call_class

  describe "#constants" do
    it 'should validate UP_VAN constant' do
      expect(described_class::UP_VAN).to eq(["Parent", "Marketing", "Data", "Product", "Product Image", "PD", "Report", "Press", "Social Media", "Conference", "Other"])
    end
  end
end