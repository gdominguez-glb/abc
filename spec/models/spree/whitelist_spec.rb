require 'rails_helper'

RSpec.describe Spree::Whitelist, type: :model do
  it { should validate_presence_of(:school_district_id) }
  it { should belong_to(:school_district) }

  before(:each) do
    @country = create :spree_country

    @state = create :spree_state, country: @country
  end

  describe '#schools' do
    it 'returns schools entries for skip ToS whitelist' do
      school = create :school_district, name: 'Colegio Motolinia',
                      country: @country,
                      state: @state
      school_2 = create :school_district, name: 'Colegio Motolinia',
                        country: @country,
                        state: @state
      create :spree_whitelist, school_district: school_2
      create :spree_whitelist, school_district: school

      expect(Spree::Whitelist.schools.count).to eq(2)
      expect(Spree::Whitelist.districts.count).to eq(0)
    end
  end

  describe '#districts' do
    it 'returns districts entries for skip ToS whitelist' do
      district = create :school_district, name: 'Colegio Motolinia',
                        country: @country,
                        state: @state,
                        place_type: SchoolDistrict.place_types[:district]
      district_2 = create :school_district, name: 'Colegio Motolinia',
                          country: @country,
                          state: @state,
                          place_type: SchoolDistrict.place_types[:district]
      create :spree_whitelist, school_district: district_2
      create :spree_whitelist, school_district: district

      expect(Spree::Whitelist.districts.count).to eq(2)
      expect(Spree::Whitelist.schools.count).to eq(0)
    end
  end
end
