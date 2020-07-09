FactoryBot.define do
  factory :notification_trigger do
    target_type { "MyString" }
    user_type { "MyString" }
    user_ids { [] }
    school_district_admin_user_id { 1 }
    content { "MyText" }
    notify_at { 3.days.from_now }
  end
end
