class Spree::VideoGroup < ApplicationRecord
  has_many :videos, class_name: 'Spree::Video'
  has_many :products, class_name: 'Spree::Product'

  after_save :create_taxon

  private

  def create_taxon
    group_taxonomy = Spree::Taxonomy.find_or_create_by(name: 'Type')
    group_taxonomy.root.children.find_or_create_by(name: self.name) if group_taxonomy
  end
end
