class Page < ActiveRecord::Base

  searchkick

  belongs_to :curriculum

  has_many :medium_publications
  has_one :event_page, ->{ where(display: true) }

  validates :slug, presence: true, uniqueness: true
  validates_presence_of :title, :group_name

  serialize :tiles

  scope :visibles, -> { where(visible: true).order('position ASC') }
  scope :curriculum_nav, -> { show_in_top_navigation.joins(:curriculum).where({curriculums: { visible: true }}) }
  scope :group_roots, -> { where(group_root: true) }
  scope :not_group_roots, -> { where(group_root: false) }
  scope :show_in_top_navigation, -> { visibles.group_roots.where(show_in_nav: true) }
  scope :show_in_sub_navigation, -> (group_name) { visibles.not_group_roots.where(group_name: group_name, show_in_nav: true) }
  scope :show_in_footer_as_top_links, -> { visibles.group_roots.where(show_in_footer: true) }
  scope :show_in_footer_as_subgroup_links, -> (group_name) { visibles.not_group_roots.where(show_in_footer: true, group_name: group_name) }

  TILES = [
    {
      name: 'Masthead',
      fields: [
        { label: 'Title', input_type: 'text' },
        { label: 'Background Image', input_type: 'text' }
      ]
    },
    {
      name: '50/50 Small Image',
      fields: [
        { label: 'Title', input_type: 'text' },
        { label: 'Description', input_type: 'text_area' },
        { label: 'Lean More Url', input_type: 'text' },
        { label: 'Image', input_type: 'text' }
      ] },
    {
      name: 'Three Columns',
      fields: [
        { label: 'Title 1', input_type: 'text' },
        { label: 'Description 1', input_type: 'text_area' },
        { label: 'Lean More Url 1', input_type: 'text' },
        { label: 'Title 2', input_type: 'text' },
        { label: 'Description 2', input_type: 'text_area' },
        { label: 'Lean More Url 2', input_type: 'text' },
        { label: 'Title 3', input_type: 'text' },
        { label: 'Description 3', input_type: 'text_area' },
        { label: 'Lean More Url 3', input_type: 'text' }
      ]
    },
    {
      name: '50/50 Large Image',
      fields: [
        { label: 'Title', input_type: 'text' },
        { label: 'Description', input_type: 'text_area' },
        { label: 'Lean More Url', input_type: 'text' },
        { label: 'Download Url', input_type: 'text' },
        { label: 'Image', input_type: 'text' }
      ]
    }
  ]
end
