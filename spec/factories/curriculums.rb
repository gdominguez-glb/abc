# frozen_string_literal: true

FactoryBot.define do
  factory :curriculum do
    name { 'Math' }
    position { 1 }
    visible { false }
  end
end
