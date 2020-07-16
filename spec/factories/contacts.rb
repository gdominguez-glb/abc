# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    name { 'MyString' }
    email { 'MyString' }
    message { 'MyText' }
  end
end
