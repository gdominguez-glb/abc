require 'rails_helper'

describe Spree::Part do
  it { should belong_to(:bundle).class_name('Spree::Product').with_foreign_key(:bundle_id) }
  it { should belong_to(:product).class_name('Spree::Product').with_foreign_key(:product_id) }

  it { should validate_presence_of(:bundle_id) }
  it { should validate_presence_of(:product_id) }

  it "mark parent bundle cant be part" do
    bundle = create(:product)
    product = create(:product)
    Spree::Part.create(bundle: bundle, product: product)

    expect(bundle.reload.can_be_part).to eq(false)
  end
end
