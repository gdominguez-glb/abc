# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    blog_id { 1 }
    title { 'MyString' }
    body { 'MyText' }
    body_draft { 'MyText' }
    publish_status { 1 }
    draft_status { 1 }
    archived_at { '2017-03-28 17:28:15' }
    archived { false }
    display { false }
  end
end
