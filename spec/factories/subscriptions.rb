# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    blog_id { 1 }
    user_id { 1 }
    subscribe_status { 1 }
  end
end
