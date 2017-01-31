require 'rails_helper'

RSpec.describe RegonlineEvent, type: :model do
  before(:each) do
    Geocoder.configure(lookup: :test)
    address_mapping = { 'A,B,C,D' => [{
      'latitude' => 36.4722803,
      'longitude' => -87.3612205,
      'address' => 'B',
      'state' => 'C',
      'state_code' => 'C',
      'country' => 'D',
      'country_code' => 'D'
    }] }
    address_mapping.each do |key, value|
      Geocoder::Lookup::Test.add_stub(key, value)
    end
  end

  describe "#filter_grade_bands constant" do
    it 'should return the filter_grade_bands constant' do
      expect(RegonlineEvent::FILTER_GRADE_BANDS).to eq(["PK", "K-2", "3-5", "6-8", "9-12"])
    end
  end

  describe "#to_partial_path" do
    it "set default partial path" do
      expect(RegonlineEvent.new.to_partial_path).to eq('events/event')
    end
  end

  describe "#training_type" do
    it "extract traning type from client event id" do
      event = RegonlineEvent.new(client_event_id: 'ABc,EFG')
      expect(event.training_type).to eq('EFG')
    end
  end

  describe ".with_filter" do
    let!(:event) { create(:regonline_event, client_event_id: 'aaron', location_name: 'A', city: 'B', state: 'C', country: 'D') }

    it "return events that client_event_id match filter ignore cases" do
      expect(RegonlineEvent.with_filter('aaron')).to eq([event])
      expect(RegonlineEvent.with_filter('Aaron')).to eq([event])
    end
  end

  describe ".import" do
    let(:regonline_data) do
      ["ID", "Title", "StartDate", "EndDate", "ActiveDate", "City", "State", "Country", "PostalCode", "LocationName", "LocationRoom", "LocationBuilding", "LocationAddress1", "LocationAddress2", "Latitude", "Longitude", "ClientEventID"]
      {
        "ID" => '123321',
        "Title" => 'Eureka Lesson',
        "Latitude" => 36.4722803,
        "Longitude" => -87.3612205,
        "LocationName" => "A",
        "City" => "B",
        "State" => "C",
        "Country" => "D"
      }
    end

    it "import regonline event from data" do
      RegonlineEvent.import(regonline_data)

      expect(RegonlineEvent.last.regonline_id).to eq('123321')
    end
  end
end
