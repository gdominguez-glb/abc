FactoryGirl.define do
  factory :spree_product_distribution, :class => 'Spree::ProductDistribution' do
    from_user { gm_user }
    to_user { gm_user }
    quantity 1
    email
    product
  end

end
