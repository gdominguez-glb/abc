class EventTraining < ActiveRecord::Base
  validates_presence_of :title, :content

  def title_to_slug
    title.parameterize
  end

  searchkick callbacks: :async

  acts_as_list

  def search_data
    {
      title: title,
      content: content,
      user_ids: [-1]
    }
  end
end
