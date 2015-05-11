FactoryGirl.define do
  factory :spree_product_distribution, :class => 'Spree::ProductDistribution' do
    licensed_product_id 1
    from_user_id 1
    to_user_id 1
    quantity 1
    email "MyString"
    product_id 1
  end

end
