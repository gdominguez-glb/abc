# frozen_string_literal: true

FactoryBot.define do
  factory :custom_field_value do
    custom_field_id { 1 }
    value { 'MyText' }
  end
end
