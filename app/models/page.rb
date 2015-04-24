class Page < ActiveRecord::Base
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :group_name, presence: true

end
