# frozen_string_literal: true

FactoryBot.define do
  factory :gm_user, class: Spree::User do
    first_name { 'John' }
    last_name { 'Doe' }
    email
    school_district
    password { '123456' }
    interested_subjects { ["math"] }
    skip_salesforce_create { true }
    ship_address
    bill_address
    accepted_terms { true }
    accepted_terms_2018 { true }
    title { 'Homeschooler' }
    zip_code { '10000' }
    after(:create) do |u|
      create(:salesforce_reference, local_object: u)
    end
  end
end
