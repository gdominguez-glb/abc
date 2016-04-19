class VanityUrl < ActiveRecord::Base
  validates :url, presence: true, url: true
  validates :redirect_url, presence: true, url: true
end
