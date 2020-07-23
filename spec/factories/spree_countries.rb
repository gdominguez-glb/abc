# frozen_string_literal: true

FactoryBot.define do
  factory :spree_country, :class => 'Spree::Country' do
    iso_name { 'UNITED STATES' }
    iso { 'US' }
    iso3 { 'USA' }
    name { 'United States' }
    numcode { 840 }
  end
end
