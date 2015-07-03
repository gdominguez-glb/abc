FactoryGirl.define do
  factory :notification_trigger do
    target_type "MyString"
    user_type "MyString"
    user_ids "MyText"
    school_district_admin_user_id 1
    content "MyText"
  end
end
