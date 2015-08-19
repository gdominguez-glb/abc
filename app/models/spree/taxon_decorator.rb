Spree::Taxon.class_eval do
  has_many :video_classifications, -> { order(:position) }, dependent: :delete_all, inverse_of: :taxon
  has_many :videos, through: :video_classifications
end
