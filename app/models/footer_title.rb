class FooterTitle < ActiveRecord::Base
  has_many :footer_links

  acts_as_list scope: :footer_links
end
