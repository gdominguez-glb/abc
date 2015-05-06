FactoryGirl.define do
  factory :spree_licensed_product, :class => 'Spree::LicensedProduct' do
    user_id 1
    product_id 1
    order_id 1
    expire_at "2015-05-06 20:23:50"
  end

end
