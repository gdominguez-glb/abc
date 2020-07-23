# frozen_string_literal: true

FactoryBot.define do
  factory :custom_field_option do
    custom_field_id { 1 }
    value { 'MyString' }
    label { 'MyString' }
  end
end
