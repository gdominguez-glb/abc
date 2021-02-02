# frozen_string_literal: true

FactoryBot.define do
  factory :training_type_category do
    title { 'MyString' }
    description { 'MyText' }
    is_default { false }
  end
end
