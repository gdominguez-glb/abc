class FooterTitle < ApplicationRecord
  has_many :footer_links, ->{ order('position asc') }, dependent: :destroy

  acts_as_list
end
