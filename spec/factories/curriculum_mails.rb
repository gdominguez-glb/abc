# frozen_string_literal: true

FactoryBot.define do
  factory :curriculum_mail do
    subject { 'MyString' }
    content { 'MyText' }
    status { 1 }
  end
end
