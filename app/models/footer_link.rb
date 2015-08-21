class FooterLink < ActiveRecord::Base
  belongs_to :footer_title
  acts_as_list scope: :footer_title
end
