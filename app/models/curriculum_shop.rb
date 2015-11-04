class CurriculumShop < ActiveRecord::Base
  validates_presence_of :title, :url, :page_id
end
