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

  describe '#skip_terms?' do
    context 'with district' do
      it 'returns true if the user will skip terms and conditions' do
        district = create :school_district, name: 'Motolinia',
                          country: @country,
                          state: @state,
                          place_type: SchoolDistrict.place_types[:district]
        create :spree_whitelist, school_district: district
        user = create :gm_user, school_district: district

        expect(Spree::Whitelist.skip_terms?(user: user)).to eq(true)
      end

      it 'returns false if the user won\'t skip terms and conditions' do
        district = create :school_district, name: 'Motolinia',
                          country: @country,
                          state: @state,
                          place_type: SchoolDistrict.place_types[:district]
        user_district = create :school_district, name: 'San Luis District',
                               country: @country,
                               state: @state,
                               place_type: SchoolDistrict.place_types[:district]
        create :spree_whitelist, school_district: district
        user = create :gm_user, school_district: user_district

        expect(Spree::Whitelist.skip_terms?(user: user)).to eq(false)
      end
    end

    context 'with school' do
      it 'returns true if the user will skip terms and conditions' do
        school = create :school_district, name: 'Colegio Motolinia',
                          country: @country,
                          state: @state,
                          place_type: SchoolDistrict.place_types[:school]
        create :spree_whitelist, school_district: school
        user = create :gm_user, school_district: school

        expect(Spree::Whitelist.skip_terms?(user: user)).to eq(true)
      end

      it 'returns false if the user won\'t skip terms and conditions' do
        school = create :school_district, name: 'Colegio Motolinia',
                          country: @country,
                          state: @state,
                          place_type: SchoolDistrict.place_types[:school]
        user_school = create :school_district, name: 'San Luis District',
                          country: @country,
                          state: @state,
                          place_type: SchoolDistrict.place_types[:school]
        create :spree_whitelist, school_district: school
        user = create :gm_user, school_district: user_school

        expect(Spree::Whitelist.skip_terms?(user: user)).to eq(false)
      end
    end
  end
end
