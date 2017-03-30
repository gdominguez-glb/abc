class Article < ActiveRecord::Base
  include Displayable
  include Archiveable
  include Publishable
  publishable name: :body

  belongs_to :blog
  belongs_to :user, class_name: 'Spree::User'

  validates_presence_of :title, :body_draft, :slug
  validates_uniqueness_of :slug

  has_attached_file :jumbotron_background, path: "/:class/:attachment/:id_partition/:style/:filename"
  validates_attachment_content_type :jumbotron_background, content_type: /\Aimage\/.*\z/
  validates_attachment_presence :jumbotron_background

  scope :sorted, -> { order('publish_date desc') }
end
