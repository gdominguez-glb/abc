class MediumPublication < ActiveRecord::Base
  validates_presence_of :title, :url

  BLOG_TYPES = ['global', 'curriculum']

  has_many :posts

  scope :global, -> { where(blog_type: 'global').order('position asc') }
end
