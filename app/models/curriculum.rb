class Curriculum < ActiveRecord::Base
  validates_presence_of :name

  has_many :pages

  scope :visibles, -> { where(visible: true).order('position ASC') }
end
