class Job < ApplicationRecord
  include Displayable
  include Archiveable
  include Publishable
  publishable name: :content

  acts_as_list

  searchkick callbacks: :async

  def should_index?
    display?
  end

  def search_data
    {
      title: title,
      content: content,
      user_ids: [-1]
    }
  end

end
