class MediumPublication < ApplicationRecord
  include Displayable

  validates_presence_of :title, :url, :slug

  BLOG_TYPES = ['global', 'curriculum']

  scope :sorted, ->{ order('position asc') }

  has_many :posts, dependent: :destroy
  belongs_to :page

  BLOG_TYPES.each do |blog_type|
    scope blog_type, -> { where(display: true).where(blog_type: blog_type).where("slug is not null").order('position asc') }
  end

  def global?
    blog_type == 'global'
  end

  def curriculum?
    blog_type == 'curriculum'
  end

  searchkick callbacks: :async

  def should_index?
    self.display?
  end

  def search_data
    {
      title: title,
      feature: 'blog',
      user_ids: [-1]
    }
  end
end
