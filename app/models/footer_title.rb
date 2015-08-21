class FooterTitle < ActiveRecord::Base
  has_many :footer_links, dependent: :destroy

  acts_as_list
end
