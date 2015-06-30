FactoryGirl.define do
  factory :gm_user, class: Spree::User do
    first_name 'John'
    last_name 'Doe'
    email
    school_district
    password '123456'
  end
end
