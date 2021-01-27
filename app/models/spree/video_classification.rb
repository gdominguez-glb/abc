class Spree::VideoClassification < ApplicationRecord
  self.table_name = 'spree_taxons_videos'

  acts_as_list scope: :taxon
  belongs_to :video, class_name: "Spree::Video", inverse_of: :video_classifications
  belongs_to :taxon, class_name: "Spree::Taxon", inverse_of: :video_classifications, touch: true

  validates_uniqueness_of :taxon_id, scope: :video_id, message: :already_linked
end
