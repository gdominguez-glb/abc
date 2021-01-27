# frozen_string_literal: true

FactoryBot.define do
  factory :spree_group_item, :class => 'Spree::GroupItem' do
    group_id { 1 }
    product_id { 1 }
  end
end
