class EventTraining < ApplicationRecord
  validates_presence_of :title, :content

  belongs_to :training_type_category
  belongs_to :event_training_header

  CATEGORIES = ['english', 'math']

  scope :by_category, ->(category) { where(category: category) }

  def title_to_slug
    title.parameterize
  end

  acts_as_list scope: :training_type_category

  def title_with_category
    [title, category].compact.join(' - ')
  end
end
