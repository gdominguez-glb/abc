class EventTraining < ActiveRecord::Base
  validates_presence_of :title, :content

  def title_to_slug
    title.parameterize
  end

  searchkick callbacks: :async

  def search_data
    {
      title: title,
      content: content
    }
  end
end
