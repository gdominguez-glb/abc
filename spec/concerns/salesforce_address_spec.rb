require 'rails_helper'

RSpec.describe SalesforceAddress do
  let!(:country) { create(:country, iso: 'USA', name: 'United States') }
  let!(:state) { create(:state, country: country, name: 'Alabama', abbr: 'AL' ) }

  let(:addressable_class) { Struct.new(:test_class) { include SalesforceAddress } }
  let(:addressable) { addressable_class.new }

  describe "#sf_address" do
    let(:address) { create(:address, address1: 'Ad1', city: 'New York', state: state, country: country, zipcode: '10000') }

    it "generate salesfore address with address and type" do
      expect(addressable.sf_address(address, 'Billing')).to eq({"BillingStreet"=>"Ad1", "BillingCity"=>"New York", "BillingState"=>"AL", "BillingPostalCode"=>"10000", "BillingCountry"=>"USA"})
    end
  end

  describe ".valid_address_types" do
    it "specify valid address types" do
      expect(addressable_class.valid_address_types).to eq(%w(Billing Shipping Mailing Other))
    end
  end

  describe ".address_attributes_valid?" do
    it "be valid with all attributes specified" do
      address_attributes = {
        first_name: 'F',
        last_name: 'L',
        address1: 'A1',
        city: 'New York',
        country: 'US',
        zipcode: '10000',
        phone: '888-888'
      }
      expect(addressable_class.address_attributes_valid?(address_attributes)).to eq(true)
    end

    it "be invalid with any of the attributes is not specified" do
      address_attributes = {
        first_name: nil,
        last_name: 'L',
        address1: 'A1',
        city: 'New York',
        country: 'US',
        zipcode: '10000',
        phone: '888-888'
      }
      expect(addressable_class.address_attributes_valid?(address_attributes)).to eq(false)
    end
  end

  describe ".parse_state_and_country" do
    it "parse state and country from salesforce object" do
      sfo = Hashie::Mash.new({ 'BillingCountry' => 'USA', 'BillingState' => 'AL' })

      expect(addressable_class.parse_state_and_country(sfo, 'Billing')).to eq([state, country])
    end
  end

  describe ".parse_phone" do
    it "return phone from salesforce object if specified" do
      sfo = Hashie::Mash.new({'Phone' => '111-111-1111'})
      expect(addressable_class.parse_phone(sfo)).to eq('111-111-1111')
    end

    it "return placeholder if phone is not specified" do
      sfo = Hashie::Mash.new({'Phone' => ''})
      expect(addressable_class.parse_phone(sfo)).to eq('000-000-0000')
    end
  end

  describe ".address_attributes" do
    it "generate address attributes from salesforce object" do
      sfo = Hashie::Mash.new({
        'FirstName' => 'F',
        'LastName' => 'L',
        'Phone' => '111-111-1111',
        'BillingStreet' => 'Bs',
        'BillingCity' => 'New York',
        'BillingCountry' => 'USA',
        'BillingState' => 'AL',
        'BillingPostalCode' => '10000'
      })

      expect(addressable_class.address_attributes(sfo, 'Billing')).to eq({
        first_name: 'F',
        last_name: 'L',
        phone: '111-111-1111',
        address1: 'Bs',
        city: 'New York',
        state: state,
        zipcode: '10000',
        country: country
      })
    end

    it "generate nil if sfo is blank" do
      expect(addressable_class.address_attributes({}, 'Billing')).to eq(nil)
    end

    it "generate nil if address type is not valid" do
      expect(addressable_class.address_attributes(sfo = Hashie::Mash.new({ 'FirstName' => 'F' }), 'Invalid')).to eq(nil)
    end

    it "generate empty if address data is not valid" do
      expect(addressable_class.address_attributes(sfo = Hashie::Mash.new({ 'FirstName' => 'F' }), 'Billing')).to eq({})
    end
  end
end
