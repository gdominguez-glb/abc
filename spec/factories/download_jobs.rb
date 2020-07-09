FactoryBot.define do
  factory :download_job do
    user_id { 1 }
    material_ids { "MyText" }
    status { "MyString" }
    percent { 1 }
  end
end
