FactoryBot.define do
  factory :notification do
    user_id { 1 }
    notification_trigger_id { 1 }
    content { "MyText" }
    read { false }
  end
end
