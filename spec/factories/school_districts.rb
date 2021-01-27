# frozen_string_literal: true

FactoryBot.define do
  factory :school_district do
    name { 'MyString' }
    state_id { 1 }
    country_id { 1 }
    city { 'New York' }
    place_type { SchoolDistrict.place_types[:school] }
    skip_salesforce_create { true }
    after(:create) do |s|
      create(:salesforce_reference, local_object: s)
    end
  end
end
