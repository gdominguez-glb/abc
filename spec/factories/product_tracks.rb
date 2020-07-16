# frozen_string_literal: true

FactoryBot.define do
  factory :product_track do
    user_id { 1 }
    product_id { 1 }
    material_id { 1 }
  end
end
