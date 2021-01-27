class CurriculumShop < ApplicationRecord
  validates_presence_of :title, :url, :page_id

  belongs_to :page
end
