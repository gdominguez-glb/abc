class Blog < ApplicationRecord
  include Displayable

  validates_presence_of :title, :slug
  validates_uniqueness_of :slug

  enum blog_type: { global: 0, curriculum: 1 }
  scope :sorted, ->{ order('position asc') }

  belongs_to :page

  has_many :articles
  has_many :subscriptions
  has_many :users, class_name: 'Spree::User', through: :subscriptions

  blog_types.each do |blog_type, blog_type_value|
    scope blog_type, -> { where(display: true).where(blog_type: blog_type_value).where("slug is not null").order('position asc') }
  end

end
