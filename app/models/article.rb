class Article < ActiveRecord::Base
  include Displayable
  include Archiveable
  include Publishable
  publishable name: :body

  belongs_to :blog
  validates_presence_of :title, :body_draft, :slug

  has_attached_file :jumbotron_background, path: "/:class/:attachment/:id_partition/:style/:filename"
  validates_attachment_content_type :jumbotron_background, content_type: /\Aimage\/.*\z/
end
