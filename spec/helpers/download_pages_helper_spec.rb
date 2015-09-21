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

  describe "#show_grade_material?" do
    let!(:user) { create(:gm_user) }
    let!(:product) { create(:product, is_grades_product: true) }
    let!(:material) { create(:spree_material, product: product, name: 'Grade 3', parent: nil) }

    before(:each) do
      allow(controller).to receive(:current_spree_user).and_return(user)
    end

    it "return true if product is not grades product" do
      product = create(:product, is_grades_product: false)

      expect(helper.show_grade_material?(product, nil)).to eq(true)
    end

    it "return true if user dont set grade option" do
      user.settings[:grade_option] = nil
      expect(helper.show_grade_material?(product, nil)).to eq(true)
    end

    it "return true if material name match user grade option" do
      user.settings[:grade_option] = 'Grade 3'

      expect(helper.show_grade_material?(product, material)).to eq(true)
    end

    it "return false if material name not match user grade option" do
      user.settings[:grade_option] = 'Grade 4'

      expect(helper.show_grade_material?(product, material)).to eq(false)
    end
  end
end
