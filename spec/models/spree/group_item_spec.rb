require 'rails_helper'

RSpec.describe Spree::GroupItem, type: :model do
  it { should belong_to(:group).class_name('Spree::Product') }
  it { should belong_to(:product).class_name('Spree::Product') }

  let(:group_product) { create(:product) }
  let(:product) { create(:product) }

  it "mark product not saleable in storefront when add to group" do
    Spree::GroupItem.create(group: group_product, product: product)
    expect(product.reload.show_in_storefront).to eq(false)
  end

  it "revert product to be saleable after remove from group item" do
    group_item = Spree::GroupItem.create(group: group_product, product: product)
    group_item.destroy

    expect(product.reload.show_in_storefront).to eq(true)
  end
end
