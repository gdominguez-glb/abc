class DownloadPage < ActiveRecord::Base
  validates_presence_of :title, :description
  validates :slug, presence: true, uniqueness: true

  has_many :download_products
  has_many :products, through: :download_products

  before_save :lowercase_slug

  def lowercase_slug
    self.slug = self.slug.downcase
  end
end
