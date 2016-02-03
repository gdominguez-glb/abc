module Taxonable
  extend ActiveSupport::Concern

  included do
    scope :with_taxons, ->(taxons) {
      joins(:taxons).where("spree_taxons.id" => taxons.map(&:id))
    }
  end
end
