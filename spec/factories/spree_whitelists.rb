# frozen_string_literal: true

FactoryBot.define do
  factory :spree_whitelist, class: Spree::Whitelist do
    school_district
  end
end
