FactoryGirl.define do
  factory :opportunity do
    salesforce_id "00618000004YYXdAAO"
    skip_tax_exemption "1"
    po_number "123123"

    factory :opportunity_with_attachment do
      after(:build){ |attachment| attachment.attachments << FactoryGirl.build(:opportunity_attachment) }
    end
  end

end
