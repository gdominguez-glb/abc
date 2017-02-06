FactoryGirl.define do
  factory :spree_taxon, class: Spree::Taxon do
    name 'Ruby on Rails'
    taxonomy
    parent_id nil
  end
end
