require 'marketing_page_renderrer'

class Page < ActiveRecord::Base

  include Archiveable
  include Publishable
  publishable name: :body

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
  has_many :event_pages, ->{ where(display: true) }

  has_one :shop, class_name: 'CurriculumShop', foreign_key: :page_id
  has_one :custom_css

  validates :slug, presence: true, uniqueness: true
  validates_presence_of :title, :group_name

  serialize :tiles

  scope :visibles, -> { where(visible: true).order('position ASC') }
  scope :curriculum_nav, -> { show_in_top_navigation.joins(:curriculum).where({curriculums: { visible: true }}).order('curriculums.position asc') }
  scope :group_roots, -> { where(group_root: true) }
  scope :not_group_roots, -> { where(group_root: false) }
  scope :show_in_top_navigation, -> { visibles.group_roots.where(show_in_nav: true) }
  scope :show_in_sub_navigation, -> (group_name) { visibles.not_group_roots.where(group_name: group_name, show_in_nav: true) }
  scope :show_in_footer_as_top_links, -> { visibles.group_roots.where(show_in_footer: true) }
  scope :show_in_footer_as_subgroup_links, -> (group_name) { visibles.not_group_roots.where(show_in_footer: true, group_name: group_name) }
  scope :by_category, -> (category) {
    if category == 'Footer'
      where(show_in_footer: true)
    elsif category == 'Enterprise'
      where(show_in_footer: false, curriculum_id: nil)
    else
      joins(:curriculum).where(curriculums: { name: category })
    end
  }


  before_save :lowercase_group_name
  #before_save :generate_page_from_tiles

  TILES = YAML.load_file(Rails.root.join('config/tiles.yml'))

  def sub_pages
    Page.show_in_sub_navigation(self.group_name)
  end

  def available_event_pages
    event_pages.select{|event_page| event_page.events.exists? }
  end

  def blank_tiles?
    tiles.blank? || tiles[:rows].blank?
  end

  private

  def generate_page_from_tiles
    if self.tiles.present?
      sanitize_tiles
      self.body = MarketingPageRenderrer.new(self).render
    end
  end

  include ActionView::Helpers::SanitizeHelper

  def sanitize_tiles
    self.tiles[:rows].each do |tile|
      tile.each do |k, v|
        next unless v.is_a?(String)
        tile[k] = sanitize(v.strip, attributes: ['href', 'target', 'title'])
      end
    end
  end

  def lowercase_group_name
    self.group_name = self.group_name.strip.downcase if self.group_name.present?
  end
end
