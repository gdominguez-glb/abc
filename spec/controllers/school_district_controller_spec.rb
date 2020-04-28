# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SchoolDistrictsController, type: :controller do
  describe 'GET index' do
    it 'return the list of School Districts' do
      create_list :school_district, 5, place_type: 'school',
                                       sf_is_deleted: false,
                                       sf_verified: true
      params = {
        type: 'school',
        q: 'MyS',
        page: 1,
        per_page: 3
      }

      get :index, params

      data = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(data.key?('items')).to eq(true)
      expect(data.key?('total_pages')).to eq(true)
      expect(data.key?('total_count')).to eq(true)
      expect(data['items'].count).to eq(3)
    end

    it 'return the list of School Districts filter by country' do
      country = create :spree_country
      state = create :spree_state, country: country
      state2 = create :spree_state, country: country
      create_list :school_district, 2, place_type: 'school',
                                       sf_is_deleted: false,
                                       sf_verified: true,
                                       state: state
      create_list :school_district, 5, place_type: 'school',
                                       sf_is_deleted: false,
                                       sf_verified: true,
                                       state: state2
      params = {
        type: 'school',
        q: 'MyS',
        page: 1,
        per_page: 2,
        state_id: state.id
      }

      get :index, params

      data = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(data.key?('items')).to eq(true)
      expect(data.key?('total_pages')).to eq(true)
      expect(data.key?('total_count')).to eq(true)
      expect(data['items'].count).to eq(2)
    end

    it 'return the list of School Districts filter by country' do
      country = create :country
      create_list :school_district, 2, place_type: 'school',
                                       sf_is_deleted: false,
                                       sf_verified: true,
                                       country: country
      create_list :school_district, 5, place_type: 'school',
                                       sf_is_deleted: false,
                                       sf_verified: true
      params = {
        type: 'school',
        q: 'MyS',
        page: 1,
        per_page: 2,
        country_id: country.id
      }

      get :index, params

      data = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(data.key?('items')).to eq(true)
      expect(data.key?('total_pages')).to eq(true)
      expect(data.key?('total_count')).to eq(true)
      expect(data['items'].count).to eq(2)
    end
  end

  describe 'GET show' do
    it 'return the list of School Districts' do
      district = create :school_district, place_type: 'school',
                                          sf_is_deleted: false,
                                          sf_verified: true
      params = {
        id: district.id
      }

      get :show, params

      data = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(data.key?('item')).to eq(true)
      expect(data['item']['id']).to eq(district.id)
      expect(data['item']['text']).to eq('MyString - New York')
    end
  end
end
