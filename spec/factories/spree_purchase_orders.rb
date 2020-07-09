FactoryBot.define do
  factory :spree_purchase_order, :class => 'Spree::PurchaseOrder' do
    po_number { "MyString" }
    person_to_receive_license { "MyString" }
  end

end
