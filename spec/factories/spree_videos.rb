# frozen_string_literal: true

FactoryBot.define do
  factory :spree_video, :class => 'Spree::Video' do
    title { 'MyString' }
    description { 'MyText' }
    product_id { 1 }
    is_free { false }
  end

end
