# frozen_string_literal: true

FactoryBot.define do
  factory :subscription_notification do
    subscription_id { 1 }
    article_id { 1 }
  end
end
