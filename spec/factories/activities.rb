# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    title { 'MyString' }
    item_id { 1 }
    item_type { 'MyString' }
    action { 'login' }
    user { create :gm_user }
  end
end
