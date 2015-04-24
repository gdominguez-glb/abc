class Page < ActiveRecord::Base
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :group_name, presence: true

  scope :visibles, -> {
    where(visible: true).order('position ASC')
  }
  scope :group_roots, -> {
    where(group_root: true)
  }
  scope :not_group_roots, -> {
    where(group_root: false)
  }
  scope :show_in_top_navigation, -> {
    visibles.group_roots.where(show_in_nav: true)
  }
  scope :show_in_sub_navigation, -> (group_name) {
    visibles.not_group_roots.where(group_name: group_name, show_in_nav: true)
  }
  scope :show_in_footer_as_top_links, -> {
    visibles.group_roots.where(show_in_footer: true)
  }
  scope :show_in_footer_as_subgroup_links, -> (group_name) {
    visibles.not_group_roots.where(show_in_footer: true, group_name: group_name)
  }

end
