class MediumPublication < ActiveRecord::Base
  validates_presence_of :title, :url

  BLOG_TYPES = ['global', 'curriculum']
end
