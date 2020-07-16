# frozen_string_literal: true

FactoryBot.define do
  factory :job do
    title { 'MyString' }
    content { 'MyText' }
    display { false }
  end
end
