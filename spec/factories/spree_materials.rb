FactoryGirl.define do
  factory :spree_material, :class => 'Spree::Material' do
    name "MyString"
product_id 1
parent_id 1
lft 1
rgt 1
depth 1
children_count 1
  end

end
