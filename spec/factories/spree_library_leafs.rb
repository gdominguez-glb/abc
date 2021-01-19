# frozen_string_literal: true

FactoryBot.define do
  factory :spree_library_leaf, :class => 'Spree::LibraryLeaf' do
    name { 'MyString' }
    product_id { 1 }
    position { 1 }
  end
end
