# frozen_string_literal: true

FactoryBot.define do
  factory :spree_pinned_product, :class => 'Spree::PinnedProduct' do
    product_id { 1 }
    user_id { 1 }
  end

end
