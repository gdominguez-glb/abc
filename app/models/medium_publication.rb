class MediumPublication < ActiveRecord::Base
  validates_presence_of :title, :url, :slug

  BLOG_TYPES = ['global', 'curriculum']

  scope :sorted, ->{ order('position asc') }

  has_many :posts
  belongs_to :page

  BLOG_TYPES.each do |blog_type|
    scope blog_type, -> { where(display: true).where(blog_type: blog_type).where("slug is not null").order('position asc') }
  end
end
