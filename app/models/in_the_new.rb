class InTheNew < ActiveRecord::Base
  validates :title, :slug, presence: true
  validates :slug, uniqueness: true
end
