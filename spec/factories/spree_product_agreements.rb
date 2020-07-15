# frozen_string_literal: true

FactoryBot.define do
  factory :spree_product_agreement, :class => 'Spree::ProductAgreement' do
    product_id { 1 }
    user_id { 1 }
  end

end
