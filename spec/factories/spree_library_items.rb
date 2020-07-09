FactoryBot.define do
  factory :spree_library_item, :class => 'Spree::LibraryItem' do
    name { "MyString" }
    position { 1 }
    inkling_code { "MyText" }
    item_type { "MyString" }
  end

end
