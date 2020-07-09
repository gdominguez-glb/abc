FactoryBot.define do
  factory :spree_product_agreement, :class => 'Spree::ProductAgreement' do
    product_id { 1 }
    user_id { 1 }
  end

end
