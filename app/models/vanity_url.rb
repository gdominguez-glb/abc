class VanityUrl < ActiveRecord::Base
  include Categorizable

  validates :url, presence: true, uniqueness: true, url: true
  validates :redirect_url, presence: true, url: true

  scope :search_url, ->(q) {
    where("url like :q or redirect_url like :q", q: "%#{q}%")
  }

  acts_as_taggable

  validate :must_not_be_root_url, :must_not_be_exist_path, :must_not_be_page_slug

  if File.exists?(Rails.root.join('config/vanity_urls.yml'))
    BASE_DOMAINS = YAML.load_file(Rails.root.join('config/vanity_urls.yml'))[Rails.env]
  else
    BASE_DOMAINS = ['https://greatminds.org']
  end

  attr_accessor :base_domain, :url_path

  before_validation :combine_url

  after_initialize do |vanity_url|
    if vanity_url.url.present?
      uri = URI(url)
      vanity_url.base_domain = "#{uri.scheme}://#{uri.host}"
      vanity_url.url_path = uri.path
    end
  end

  def combine_url
    if base_domain.present? && url_path.present?
      self.url = URI.join(base_domain, url_path)
    end
  end

  def must_not_be_root_url
    if path.length == 0 || path.length == 1
      self.errors.add(:url, "can't be root url")
    end
  end

  def must_not_be_exist_path
    routes = Rails.application.routes.routes
    paths = routes.collect {|r| r.path.spec.to_s.gsub('(.:format)', '').gsub(':id', '\d+') }
    paths.each do |p|
      if p.length > 1 && /#{p}/.match(path)
        self.errors.add(:url, "is used in the site.")
        break
      end
    end
  end

  def must_not_be_page_slug
    if Page.where(slug: [path, path[1..-1]]).exists?
      self.errors.add(:url, "is used by page.")
    end
  end

  def path
    @path ||= URI(url).path
  rescue
    ''
  end
end
