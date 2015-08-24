require 'rails_helper'

RSpec.describe EventPage, type: :model do
  it { should belong_to(:page) }

  it { should validate_presence_of(:page) }

  describe ".displayable" do
    let!(:event_page) { create(:event_page, display: true, page: create(:page) ) }

    it "return event pages with display" do
      expect(EventPage.displayable).to eq([event_page])
    end
  end

  describe "#events" do
    let(:event_page) { create(:event_page, display: true, page: create(:page), regonline_filter: 'Math') }

    it "return regonline events with match filter" do
      stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=A,B,C,D&language=en&sensor=false").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "", :headers => {})

      regonline_event = create(:regonline_event, client_event_id: 'Math', location_name: 'A', city: 'B', state: 'C', country: 'D')
      expect(event_page.events).to eq([regonline_event])
    end
  end
end
