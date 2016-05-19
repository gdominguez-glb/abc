Spree::Taxonomy.class_eval do
  scope :show_in_store, -> { where(show_in_store: true) }
  scope :show_in_video, -> { where(show_in_video: true) }
  scope :top_level_in_video, -> { where(top_level_in_video: true) }
end
