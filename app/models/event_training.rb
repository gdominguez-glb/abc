class EventTraining < ActiveRecord::Base
  validates_presence_of :title, :content

  def title_to_slug
    title.gsub(/[^0-9A-Za-z]/, '')
  end
end
