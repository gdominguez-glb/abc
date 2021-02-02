# frozen_string_literal: true

FactoryBot.define do
  factory :spree_material, :class => 'Spree::Material' do
    name { 'MyString' }
  end
end
