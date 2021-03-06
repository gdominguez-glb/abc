require 'rails_helper'

RSpec.describe Spree::Taxonomy, type: :model do
  describe '#show_in_store' do
    it 'should return all taxonomies in store' do
      FactoryBot.create_list(:spree_taxonomy, 3, show_in_store: true)
      FactoryBot.create_list(:spree_taxonomy, 2)
      expect(Spree::Taxonomy.show_in_store.count).to eq(3)
    end
  end

  describe '#show_in_video' do
    it 'should return all taxonomies in store' do
      FactoryBot.create_list(:spree_taxonomy, 3, show_in_video: true)
      FactoryBot.create_list(:spree_taxonomy, 2)
      expect(Spree::Taxonomy.show_in_video.count).to eq(3)
    end
  end

  describe '#top_level_in_video' do
    it 'should return all taxonomies in store' do
      FactoryBot.create_list(:spree_taxonomy, 3, top_level_in_video: true)
      FactoryBot.create_list(:spree_taxonomy, 2)
      expect(Spree::Taxonomy.top_level_in_video.count).to eq(3)
    end
  end
end