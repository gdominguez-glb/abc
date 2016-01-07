require 'rails_helper'

RSpec.describe Spree::Material, type: :model do
  let(:material) { create(:spree_material) }

  it { should belong_to(:product).class_name('Spree::Product') }
  it { should have_many(:material_files) }

  it { should validate_presence_of(:name) }

  describe "#should_index?" do
    it "return true with product" do
      material.product = create(:product)
      expect(material.should_index?).to eq(true)
    end

    it "return false without product" do
      material.product = nil
      expect(material.should_index?).to eq(false)
    end
  end

  describe "#search_data" do
    let!(:product) { create(:product) }
    let!(:material) { create(:spree_material, name: "Test", product: product) }
    let!(:user) { create(:gm_user) }
    let!(:order) { create(:order, user: user) }
    let!(:line_item) { create(:line_item, order: order, variant: product.master) }

    it "index name and user ids associate with material" do
      expect(material.search_data).to eq({
        name: material.name,
        user_ids: [user.id]
      })
    end
  end
end
