# frozen_string_literal: true

FactoryBot.define do
  factory :event_training do
    title { 'MyString' }
    content { 'MyText' }
    training_type { 'MyString' }
  end
end
