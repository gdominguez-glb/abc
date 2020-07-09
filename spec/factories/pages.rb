FactoryBot.define do
  factory :page do
    title { "MyString" }
    seo_content { "MyText" }
    slug { "MyString" }
    group_name { "MyString" }
    sub_group_name { "MyString" }
    position { 1 }
    layout { "MyString" }
    body { "MyText" }
    visible { false }
  end
end
