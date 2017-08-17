class Article < ActiveRecord::Base
  include Displayable
  include Archiveable
  include Publishable
  publishable name: :body

  belongs_to :blog
  belongs_to :user, class_name: 'Spree::User'

  validates_presence_of :title, :body_draft, :slug
  validates_uniqueness_of :slug

  scope :sorted, -> { order('publish_date desc') }
  scope :search_by_text, ->(q) { where("(title ilike :q) or (body ilike :q) or (created_by ilike :q)", q: "%#{q}%") if q.present?  }

  def next_article
    @next_article ||= related_article(:next)
  end

  def has_next_article?
    next_article.present?
  end

  def prev_article
    @prev_article ||= related_article(:prev)
  end

  def has_prev_article?
    prev_article.present?
  end

  def user_name
    created_by
  end

  def related_article(next_prev = :next)
    duck = next_prev == :prev ? ">=" : "<="
    which = next_prev == :prev ? :last : :first
    self.blog.articles.displayable.published
        .sorted
        .where("publish_date #{duck} ?", self.publish_date)
        .where.not(id: self.id)
        .send(which)
  end

  def public_url
    if self.blog.blog_type == 'global'
      Rails.application.routes.url_helpers.global_post_url(slug: self.blog.slug, id: self.slug, host: ENV['DOMAIN'])
    else
      Rails.application.routes.url_helpers.curriculum_post_url(page_slug: self.blog.page.slug, slug: self.blog.slug, id: self.slug, host: ENV['DOMAIN'])
    end
  end
end
