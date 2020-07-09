FactoryBot.define do
  factory :spree_bookmark, :class => 'Spree::Bookmark' do
    user_id { 1 }
    bookmarkable_id { 1 }
    bookmarkable_type { "MyString" }
  end

end
