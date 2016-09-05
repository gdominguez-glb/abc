require 'rails_helper'

RSpec.describe EventPage, type: :model do
  it { should belong_to(:page) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }

  describe ".displayable" do
    let!(:event_page) { create(:event_page, display: true, page: create(:page) ) }

    it "return event pages with display" do
      expect(EventPage.displayable).to eq([event_page])
    end
  end

  describe "#events" do
    let(:event_page) { create(:event_page, display: true, page: create(:page), regonline_filter: 'Math') }

    before do
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

    it "return regonline events with match filter" do
      regonline_event = create(:regonline_event, client_event_id: 'Math', location_name: 'A', city: 'B', state: 'C', country: 'D')
      expect(event_page.events).to eq([regonline_event])
    end
  end

  describe "#should_index?" do
    let(:event_page) { build(:event_page) }

    it 'return true for displayable event page' do
      event_page.display = true
      expect(event_page.should_index?).to eq(true)
    end

    it "return false for non-displayable event page" do
      event_page.display = false
      expect(event_page.should_index?).to eq(false)
    end
  end

  describe "#search_data" do
    let(:event_page) { create(:event_page, title: 'E', description: 'D', display: true ) }

    it "return data to index" do
      expect(event_page.search_data).to eq({ title: 'E', description: 'D', user_ids: [-1], :events_text => "", feature: 'events' })
    end
  end
end
