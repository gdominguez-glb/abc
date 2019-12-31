# frozen_string_literal: true

FactoryGirl.define do
  factory :spree_flipbook_leaf, class: 'Spree::FlipbookLeaf' do
    name 'MyString'
    product_id 1
    position 1
  end
end
