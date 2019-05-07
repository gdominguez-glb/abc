FactoryGirl.define do
  factory :spree_state, :class => 'Spree::State' do
    name 'Los Angeles'
    abbr 'LA'
    country
  end
end
