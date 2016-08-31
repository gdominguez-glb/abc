class Job < ActiveRecord::Base
  scope :displayable, ->{ where(display: true) }

  acts_as_list

  searchkick callbacks: :async, personalize: "user_ids"

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
