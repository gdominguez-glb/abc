require 'rails_helper'

RSpec.describe DownloadPagesHelper do

  describe "#nested_materials" do
    let(:product) { create(:product) }
    let(:material_a) { build(:spree_material, name: 'A', parent: nil) }
    let(:material_b) { build(:spree_material, name: 'B', parent: nil) }

    it "return structure materials result" do
      product.materials << material_a
      product.materials << material_b
      result = helper.nested_materials(product.materials)

      expect(result.map(&:material)).to eq([material_a, material_b])
    end
  end
end
