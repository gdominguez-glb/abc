# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    medium_publication_id { 1 }
    title { 'MyString' }
    subtitle { 'MyString' }
    published_at { '2015-06-16 20:54:59' }
    medium_id { 'MyString' }
    body { 'MyText' }
  end
end
