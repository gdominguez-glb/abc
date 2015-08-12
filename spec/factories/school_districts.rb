FactoryGirl.define do
  factory :school_district do
    name 'MyString'
    state_id 1
    place_type SchoolDistrict.place_types[:school]
    skip_salesforce_create true
  end
end
