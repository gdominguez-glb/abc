class CurriculumShop < ActiveRecord::Base
  validates_presence_of :title, :url, :page_id

  belongs_to :page
end
