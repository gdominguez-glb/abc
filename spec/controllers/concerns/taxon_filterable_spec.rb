require 'rails_helper'

RSpec.describe TaxonFilterable do
  let (:test_class) { Struct.new(:test_class) { include TaxonFilterable } }
  let(:processor) { test_class.new }
  let(:klass) { Spree::Product }
  let(:taxon) { create(:spree_taxon) }
  let(:fake_models) { Spree::Product.all }

  describe '#filter_by_taxons' do
    before(:each){ create_list(:product, 3) }

    it 'should return the same fake_models' do
      expect(processor.filter_by_taxons(klass, fake_models, [])).to eq(fake_models)
    end

    it 'should return fake_models filtered by taxons' do
      fake_models.first.taxons << taxon
      expect(processor.filter_by_taxons(klass, fake_models, [taxon.id])).to eq([fake_models.first])
    end
  end
end
