# frozen_string_literal: true

FactoryBot.define do
  factory :opportunity_attachment do
    skip_salesforce_create { true }
    file { Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/fixtures/image.png",
                                        'image/png') }
    category { 'purchase' }
  end
end
