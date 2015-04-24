class Document < ActiveRecord::Base
  has_attached_file :attachment

  validates_presence_of :name, :category
  validates_attachment :attachment, presence: true, content_type: { content_type: /\A*\Z/ }

  acts_as_taggable
end
