class EventTraining < ActiveRecord::Base
  validates_presence_of :title, :content

  belongs_to :training_type_category
  belongs_to :event_training_header

  CATEGORIES = ['english', 'math']

  scope :by_category, ->(category) { where(category: category) }

  def title_to_slug
    title.parameterize
  end

  searchkick merge_mappings: true, mappings: {
    event_tranining: {
      properties: {
        content: {type: "string", index: "not_analyzed", ignore_above: 256}
      }
    }
  }, callbacks: :async

  acts_as_list scope: :training_type_category

  def search_data
    {
      title: title,
      content: content,
      user_ids: [-1]
    }
  end

  def title_with_category
    [title, category].compact.join(' - ')
  end
end
