class FooterLink < ActiveRecord::Base
  belongs_to :footer_title
  acts_as_list
end
