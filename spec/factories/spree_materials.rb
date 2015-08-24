FactoryGirl.define do
  factory :spree_material, :class => 'Spree::Material' do
    name "MyString"
    product_id 1
    parent_id 1
  end

end
