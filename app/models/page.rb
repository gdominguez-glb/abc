class Page < ActiveRecord::Base
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :group_name, presence: true

  scope :visibles, -> { where(visible: true).order('position ASC') }
  scope :show_in_top_navigation, -> { visibles.where(group_root: true, show_in_nav: true) }
  scope :show_in_sub_navigation, -> (group_name) { visibles.where(group_name: group_name, show_in_nav: true) }
  scope :show_in_footer_links, -> { visibles.where(show_in_footer: true)}

end
