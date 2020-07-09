FactoryBot.define do
  factory :blog do
    title { 'MyString' }
    blog_type { 1 }
    position { 1 }
    display { false }
    slug { 'MyString' }
    header { 'MyString' }
    description { 'MyText' }
    page_id { 1 }
  end

end
