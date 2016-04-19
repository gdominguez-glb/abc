class VanityUrl < ActiveRecord::Base
  validates_presence_of :url, :redirect_url
end
