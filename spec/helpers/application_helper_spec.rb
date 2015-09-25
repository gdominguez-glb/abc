require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#store_active_class" do
    it "return active for url that start with store" do
      controller.request.path = '/store/products'

      expect(helper.store_active_class).to eq('active')
    end

    it "return empty in login page" do
      controller.request.path = '/store/login'

      expect(helper.store_active_class).to eq('')
    end

    it "return empty for url that outside of store" do
      controller.request.path = '/page/123'

      expect(helper.store_active_class).to eq('')
    end
  end

  describe "#store_generate_taxon_ids_param" do
    let!(:taxon) { create(:taxon) }
    let!(:other_taxon) { create(:taxon) }
    let!(:sibling_ids) { [taxon.id, other_taxon.id] }
    let!(:taxon_ids) { [other_taxon.id] }

    it "add current taxon id and remove sibling id" do
      expect(helper.store_generate_taxon_ids_param(taxon_ids, sibling_ids, taxon)).to eq([taxon.id])
    end
  end
end
