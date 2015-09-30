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
      name: '50/50 Full-Bleed Image Right',
      fields: [
        { name: 'title', label: 'Title', input_type: 'text' },
        { name: 'body_text', label: 'Body Text', input_type: 'text_area' },
        { name: 'background_color', label: 'Background Color', input_type: 'text' },
        { name: 'button_title', label: 'Button Title', input_type: 'text' },
        { name: 'button_link', label: 'Button Link', input_type: 'text' },
        { name: 'image_url', label: 'Image Url', input_type: 'text' }
      ]
    },
    {
      name: '50/50 Content Image Left',
      fields: [
        { name: 'title', label: 'Title', input_type: 'text' },
        { name: 'body_text', label: 'Body Text', input_type: 'text_area' },
        { name: 'background_color', label: 'Background Color', input_type: 'text' },
        { name: 'button_title', label: 'Button Title', input_type: 'text' },
        { name: 'button_link', label: 'Button Link', input_type: 'text' },
        { name: 'image_url', label: 'Image Url', input_type: 'text' }
      ] },
    {
      name: '50/50 Full-Bleed Image Left',
      fields: [
        { name: 'title', label: 'Title', input_type: 'text' },
        { name: 'body_text', label: 'Body Text', input_type: 'text_area' },
        { name: 'background_color', label: 'Background Color', input_type: 'text' },
        { name: 'button_1_title', label: 'Button 1 Title', input_type: 'text' },
        { name: 'button_1_link', label: 'Button 1 Link', input_type: 'text' },
        { name: 'button_2_title', label: 'Button 2 Title', input_type: 'text' },
        { name: 'button_1_link', label: 'Button 2 Link', input_type: 'text' },
        { name: 'image_url', label: 'Image Url', input_type: 'text' }
      ]
    },
    {
      name: 'Full Width Text',
      fields: [
        { name: 'title', label: 'Title', input_type: 'text' },
        { name: 'body_text', label: 'Body Text', input_type: 'text_area' },
        { name: 'background_color', label: 'Background Color', input_type: 'text' },
        { name: 'button_title', label: 'Button Title', input_type: 'text' },
        { name: 'button_link', label: 'Button Link', input_type: 'text' },
      ]
    },
    {
      name: 'Image Background, Text Left',
      fields: [
        { name: 'title', label: 'Title', input_type: 'text' },
        { name: 'body_text', label: 'Body Text', input_type: 'text_area' },
        { name: 'button_title', label: 'Button Title', input_type: 'text' },
        { name: 'button_link', label: 'Button Link', input_type: 'text' },
        { name: 'image_url', label: 'Image Url', input_type: 'text' },
      ]
    },
    {
      name: '3-Column Text',
      fields: [
        { name: 'background_color', label: 'Background Color', input_type: 'text' },
        { name: 'title_1', label: 'Title 1', input_type: 'text' },
        { name: 'body_text_1', label: 'Body Text 1', input_type: 'text_area' },
        { name: 'button_title_1', label: 'Button Title 1', input_type: 'text' },
        { name: 'button_link_1', label: 'Button Link 1', input_type: 'text' },
        { name: 'title_2', label: 'Title 2', input_type: 'text' },
        { name: 'body_text_2', label: 'Body Text 2', input_type: 'text_area' },
        { name: 'button_title_2', label: 'Button Title 2', input_type: 'text' },
        { name: 'button_link_2', label: 'Button Link 2', input_type: 'text' },
        { name: 'title_3', label: 'Title 3', input_type: 'text' },
        { name: 'body_text_3', label: 'Body Text 3', input_type: 'text_area' },
        { name: 'button_title_3', label: 'Button Title 3', input_type: 'text' },
        { name: 'button_link_3', label: 'Button Link 3', input_type: 'text' }
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
