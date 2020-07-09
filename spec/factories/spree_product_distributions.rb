FactoryBot.define do
  factory :spree_product_distribution, :class => 'Spree::ProductDistribution' do
    from_user { create(:gm_user) }
    to_user { create(:gm_user) }
    quantity { 1 }
    email
    licensed_product { create(:product) }
    product { create(:product) }
  end
end
