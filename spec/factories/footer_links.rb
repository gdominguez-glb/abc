# frozen_string_literal: true

FactoryBot.define do
  factory :footer_link do
    footer_title_id { 1 }
    name { 'MyString' }
    link { 'MyString' }
    position { 1 }
  end
end
