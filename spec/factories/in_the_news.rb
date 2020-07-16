# frozen_string_literal: true

FactoryBot.define do
  factory :in_the_new do
    call_to_action_button_link { 'MyString' }
    call_to_action_button_target { 'MyString' }
    call_to_action_button_text { 'MyString' }
    title { 'MyString' }
    author { 'MyString' }
    publisher { 'MyString' }
    slug { 'MyString' }
    image_url { 'MyString' }
    article_date { '2017-05-23 10:06:16' }
    description { 'MyString' }
  end
end
