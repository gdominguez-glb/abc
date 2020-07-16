# frozen_string_literal: true

FactoryBot.define do
  factory :faq_category do
    name { 'MyString' }
    position { 1 }
    display { false }
  end
end
