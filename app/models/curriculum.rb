class Curriculum < ApplicationRecord
  validates_presence_of :name

  has_many :pages

  scope :visibles, -> { where(visible: true).order('position ASC') }

  def teacher_page
    pages.find_by(title: 'Teachers').try(:slug)
  end

  def shop_page
    pages.where("title like ?", "%Shop%").first.try(:slug)
  end

  def parent_page
    pages.find_by(title: 'Parents').try(:slug)
  end

  def admin_page
    pages.find_by(title: 'Admins').try(:slug)
  end
end
