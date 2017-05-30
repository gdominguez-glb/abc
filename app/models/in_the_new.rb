class InTheNew < ActiveRecord::Base
  include Orderable

  scope :search_by_title, ->(q) { where("title ilike ?", "%#{q}%") if q.present? }
  scope :search_by_author, ->(q) { where("author ilike ?", "%#{q}%") if q.present? }
  scope :search_by_publisher, ->(q) { where("publisher ilike ?", "%#{q}%") if q.present? }
  scope :search_by_article_date, ->(q) { where('article_date > ? AND article_date < ?', DateTime.parse(q).beginning_of_day, DateTime.parse(q).end_of_day) if q.present? }
  scope :search_by_description, ->(q) { where("description ilike ?", "%#{q}%") if q.present? }

  validates :title, presence: true
end
