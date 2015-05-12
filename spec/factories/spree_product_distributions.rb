FactoryGirl.define do
  factory :spree_product_distribution, :class => 'Spree::ProductDistribution' do
    licensed_product
    from_user
    to_user
    quantity 1
    email
    product
  end

end
