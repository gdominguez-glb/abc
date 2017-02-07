FactoryGirl.define do
  factory :opportunity do
    salesforce_id "00618000004YYXdAAO"

    before(:create) do |opportunity, evaluator|
      opportunity.attachments << FactoryGirl.build(:attachment)
    end
  end

end
