# frozen_string_literal: true

FactoryBot.define do
  factory :spree_inkling_code, :class => 'Spree::InklingCode' do
    product_id { 1 }
    code { 'MyText' }
  end
end
