FactoryGirl.define do
  factory :gm_user, class: Spree::User do
    first_name 'John'
    last_name 'Doe'
    email
    school_district
    password '123456'
    skip_salesforce_create true
    accepted_terms true
    title 'Homeschooler'
    zip_code '10000'
    after(:create) do |u|
      create(:salesforce_reference, local_object: u)
    end
  end
end
