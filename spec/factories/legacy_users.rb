FactoryBot.define do
  factory :legacy_user, :class => 'Legacy::User' do
    email { "MyString" }
    is_school_admin { false }
    is_sub_admin { false }
    parent_admin_id { 1 }
    imported_at { "2015-11-02 16:20:19" }
  end

end
