class MediumPublication < ActiveRecord::Base
  validates_presence_of :title, :url

  BLOG_TYPES = ['global', 'curriculum']

  has_many :posts
  belongs_to :page

  BLOG_TYPES.each do |blog_type|
    scope blog_type, -> { where(display: true).where(blog_type: blog_type).order('position asc') }
  end
end
