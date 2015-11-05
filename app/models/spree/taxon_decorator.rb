Spree::Taxon.class_eval do
  has_many :video_classifications, -> { order(:position) }, dependent: :delete_all, inverse_of: :taxon
  has_many :videos, through: :video_classifications

  # override taxon.applicable_filters to remove price filter
  def applicable_filters
    fs = []
    fs << Spree::Core::ProductFilters.brand_filter if Spree::Core::ProductFilters.respond_to?(:brand_filter)
    fs
  end
end
