# frozen_string_literal: true

FactoryBot.define do
  factory :regonline_event do
    regonline_id { 'MyString' }
    title { 'MyString' }
    start_date { '2015-06-23 16:14:53' }
    end_date { '2015-06-23 16:14:53' }
    active_date { '2015-06-23 16:14:53' }
    city { 'MyString' }
    state { 'MyString' }
    country { 'MyString' }
    postal_code { 'MyString' }
    location_name { 'MyString' }
    location_room { 'MyString' }
    location_address1 { 'MyString' }
    location_address2 { 'MyString' }
    latitude { '9.99' }
    longitude { '9.99' }
  end
end
