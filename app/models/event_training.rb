class EventTraining < ActiveRecord::Base
  validates_presence_of :title, :content

  def title_to_slug
    title.gsub(/[^0-9A-Za-z]/, '')
  end

  searchkick callbacks: :async

  def search_data
    {
      title: title,
      content: content
    }
  end
end
