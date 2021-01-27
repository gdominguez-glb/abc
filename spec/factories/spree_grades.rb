# frozen_string_literal: true

FactoryBot.define do
  factory :spree_grade, :class => 'Spree::Grade' do
    name { 'MyString' }
    abbr { 'MyString' }
    school { 'MyString' }
    position { 1 }
  end
end
