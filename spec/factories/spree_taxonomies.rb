FactoryGirl.define do
  factory :spree_taxonomy, class: 'Spree::Taxonomy' do
    name 'Dummy taxon'
    position 0
    allow_multiple_taxons_selected true
    show_in_store false
    show_in_video false
    top_level_in_video false
    show_in_event_pages false
  end
end