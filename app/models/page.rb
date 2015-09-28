require 'marketing_page_renderrer'

class Page < ActiveRecord::Base

  searchkick callbacks: :async

  def should_index?
    self.visible?
  end

  def search_data
    {
      title: title,
      body: body,
      user_ids: [-1]
    }
  end

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

  before_save :generate_page_from_tiles

  TILES = [
    {
      name: 'Masthead',
      fields: [
        { name: 'title', label: 'Title', input_type: 'text' },
        { name: 'background_image', label: 'Background Image', input_type: 'text' }
      ]
    },
    {
      name: '50/50 Small Image',
      fields: [
        { name: 'title', label: 'Title', input_type: 'text' },
        { name: 'description', label: 'Description', input_type: 'text_area' },
        { name: 'learn_more_url', label: 'Learn More Url', input_type: 'text' },
        { name: 'image', label: 'Image', input_type: 'text' }
      ] },
    {
      name: 'Three Columns',
      fields: [
        { name: 'title_1', label: 'Title 1', input_type: 'text' },
        { name: 'description_1', label: 'Description 1', input_type: 'text_area' },
        { name: 'learn_more_url_1', label: 'Learn More Url 1', input_type: 'text' },
        { name: 'title_2', label: 'Title 2', input_type: 'text' },
        { name: 'description_2', label: 'Description 2', input_type: 'text_area' },
        { name: 'learn_more_url_2', label: 'Learn More Url 2', input_type: 'text' },
        { name: 'title_3', label: 'Title 3', input_type: 'text' },
        { name: 'description_3', label: 'Description 3', input_type: 'text_area' },
        { name: 'learn_more_url_3', label: 'Learn More Url 3', input_type: 'text' }
      ]
    },
    {
      name: '50/50 Large Image',
      fields: [
        { name: 'title', label: 'Title', input_type: 'text' },
        { name: 'description', label: 'Description', input_type: 'text_area' },
        { name: 'learn_more_url', label: 'Learn More Url', input_type: 'text' },
        { name: 'download_url', label: 'Download Url', input_type: 'text' },
        { name: 'image', label: 'Image', input_type: 'text' }
      ]
    }
  ]

  def sub_pages
    Page.show_in_sub_navigation(self.group_name)
  end

  private

  def generate_page_from_tiles
    if self.tiles.present?
      self.body = MarketingPageRenderrer.new(self).render
    end
  end
end
