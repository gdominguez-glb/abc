# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyString' }
    position { 1 }
    display { false }
    faq_category
  end
end
