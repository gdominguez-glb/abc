# frozen_string_literal: true

FactoryBot.define do
  factory :opportunity do
    salesforce_id { '00004269' }
    opportunity_id_sf { '00618000004YYXdAAO' }
    skip_tax_exemption { '1' }
    po_number { '123123' }
    name { 'Lucas' }
    email { 'Dummy@email.com' }
    phone_number { 'Another' }

    factory :opportunity_with_attachment do
      after(:build) { |attachment| attachment.attachments <<
                      FactoryBot.build(:opportunity_attachment) }
    end
  end
end
