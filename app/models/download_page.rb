class DownloadPage < ActiveRecord::Base
  validates_presence_of :title, :description
  validates :slug, presence: true, uniqueness: true
end
