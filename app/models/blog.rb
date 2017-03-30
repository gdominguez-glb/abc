class Blog < ActiveRecord::Base
  include Displayable

  validates_presence_of :title, :slug
  validates_uniqueness_of :slug

  enum blog_type: { global: 0, curriculum: 1 }
  scope :sorted, ->{ order('position asc') }

  belongs_to :page

  has_many :articles

  has_attached_file :jumbotron_background, path: "/:class/:attachment/:id_partition/:style/:filename"
  validates_attachment_content_type :jumbotron_background, content_type: /\Aimage\/.*\z/
  validates_attachment_presence :jumbotron_background

  blog_types.each do |blog_type, blog_type_value|
    scope blog_type, -> { where(display: true).where(blog_type: blog_type_value).where("slug is not null").order('position asc') }
  end

end
