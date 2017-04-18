require 'rails_helper'

RSpec.describe SchoolDistrict, type: :model do
  let!(:country) { create(:country, iso3: 'USA', iso: 'US', name: 'United States') }
  let!(:state) { create(:state, abbr: 'AL', name: 'Alabama', country: country) }

  it { should belong_to(:state).class_name('Spree::State') }
  it { should belong_to(:country).class_name('Spree::Country') }

  it { should have_many(:users).class_name('Spree::User') }

  it { should validate_presence_of(:name) }

  describe ".sobject_name" do
    it "sync to Account in salesforce" do
      expect(SchoolDistrict.sobject_name).to eq('Account')
    end
  end

  describe '#should_update_salesforce?' do
    it "return false" do
      expect(SchoolDistrict.new.should_update_salesforce?).to eq(false)
    end
  end

  describe "#salesforce_record_type_id" do
    it "return school type id for school record" do
      allow(SchoolDistrict).to receive(:school_type_id).and_return('school_id_123')
      expect(SchoolDistrict.new(place_type: :school).salesforce_record_type_id).to eq('school_id_123')
    end

    it "return district type id for district record" do
      allow(SchoolDistrict).to receive(:district_type_id).and_return('district_id_123')
      expect(SchoolDistrict.new(place_type: :district).salesforce_record_type_id).to eq('district_id_123')
    end

    it "return unaffiliated type id for unaffiliated record" do
      allow(SchoolDistrict).to receive(:unaffiliated_type_id).and_return('unaffiliated_id_123')
      expect(SchoolDistrict.new(place_type: :unaffiliated).salesforce_record_type_id).to eq('unaffiliated_id_123')
    end

    it "return unaffiate without place type to avoid sf sync error when school district is used somewhere" do
      allow(SchoolDistrict).to receive(:unaffiliated_type_id).and_return('unaffiliated_id_123')
      expect(SchoolDistrict.new(place_type: nil).salesforce_record_type_id).to eq('unaffiliated_id_123')
    end
  end

  describe ".record_type_id" do
    it "search in RecordType" do
      allow(RecordType).to receive(:find_in_salesforce_by_name_and_object_type).with('School', 'Account').and_return(Hashie::Mash.new({ 'Id' => 123 }))
      expect(SchoolDistrict.record_type_id('School')).to eq(123)
    end
  end

  describe ".district_type_id" do
    it "return district record type id" do
      allow(SchoolDistrict).to receive(:record_type_id).with('District').and_return('district_123')
      expect(SchoolDistrict.district_type_id).to eq('district_123')
    end
  end

  describe ".school_type_id" do
    it "return school record type id" do
      allow(SchoolDistrict).to receive(:record_type_id).with('School').and_return('school_123')
      expect(SchoolDistrict.school_type_id).to eq('school_123')
    end
  end

  describe ".unaffiliated_type_id" do
    it "return unaffiliated record type id" do
      allow(SchoolDistrict).to receive(:record_type_id).with('Unaffiliated').and_return('unaffiliated_123')
      expect(SchoolDistrict.unaffiliated_type_id).to eq('unaffiliated_123')
    end
  end

  describe ".place_type_from_salesforce_object" do
    before(:each) do
      allow(SchoolDistrict).to receive(:school_type_id).and_return('school_123')
      allow(SchoolDistrict).to receive(:district_type_id).and_return('district_123')
      allow(SchoolDistrict).to receive(:unaffiliated_type_id).and_return('unaffiliated_123')
    end

    it "return school for School Place Type" do
      sfo = Hashie::Mash.new({'RecordTypeId' => 'school_123'})
      expect(SchoolDistrict.place_type_from_salesforce_object(sfo)).to eq('school')
    end

    it "return district for District Place Type" do
      sfo = Hashie::Mash.new({'RecordTypeId' => 'district_123'})
      expect(SchoolDistrict.place_type_from_salesforce_object(sfo)).to eq('district')
    end

    it "return unaffiliated for Unaffiliated Place Type" do
      sfo = Hashie::Mash.new({'RecordTypeId' => 'unaffiliated_123'})
      expect(SchoolDistrict.place_type_from_salesforce_object(sfo)).to eq('unaffiliated')
    end

    it "return district if parentId is empty" do
      sfo = Hashie::Mash.new({'RecordTypeId' => 'some_district_id', 'ParentId' => nil})
      expect(SchoolDistrict.place_type_from_salesforce_object(sfo)).to eq('district')
    end

    it "return school if parentId is not empty" do
      sfo = Hashie::Mash.new({'RecordTypeId' => 'some_school_id', 'ParentId' => 'district_123'})
      expect(SchoolDistrict.place_type_from_salesforce_object(sfo)).to eq('school')
    end
  end

  describe ".country_from_salesforce_object" do
    it "return country from country with salesforce billing country" do
      sfo = Hashie::Mash.new(BillingCountry: 'US')
      expect(SchoolDistrict.country_from_salesforce_object(sfo)).to eq(country)
    end

    it "return us if country billing country is empty" do
      sfo = Hashie::Mash.new(BillingCountry: '')
      expect(SchoolDistrict.country_from_salesforce_object(sfo)).to eq(country)
    end
  end

  describe ".state_from_salesforce_object" do

    it "return nil if billing state is empty" do
      sfo = Hashie::Mash.new(BillingState: '')
      expect(SchoolDistrict.state_from_salesforce_object(sfo)).to eq(nil)
    end

    it "return state with billing state abbr" do
      sfo = Hashie::Mash.new(BillingState: 'AL')
      expect(SchoolDistrict.state_from_salesforce_object(sfo)).to eq(state)
    end
  end

  describe "#attributes_for_salesforce" do
    it 'return school/district attributes for salesforce' do
      allow(SchoolDistrict).to receive(:record_type_id).with('School').and_return('school_123') 
      school = SchoolDistrict.create(name: 'School A', place_type: :school, country: country, state: state, city: 'New York')
      expect(school.attributes_for_salesforce).to eq({
        "Name" => "School A",
        "RecordTypeId" => "school_123",
        "BillingState" => state.abbr,
        "BillingCity" => "New York",
        "Website_ID__c" => school.id,
        "BillingCountry" => "US"
      })
    end
  end

  describe ".with_state" do
    let!(:school_district) { create(:school_district, country: country, state: state) }

    it "return school district with state" do
      expect(SchoolDistrict.with_state(state.id)).to eq([school_district])
    end
  end
end
