class InTheNew < ActiveRecord::Base
  include Orderable

  scope :search_by_title, ->(q) { where("title ilike ?", "%#{q}%") if q.present? }
  scope :search_by_author, ->(q) { where("author ilike ?", "%#{q}%") if q.present? }
  scope :search_by_publisher, ->(q) { where("publisher ilike ?", "%#{q}%") if q.present? }
  scope :search_by_article_date, ->(q) { where('article_date > ? AND article_date < ?', DateTime.parse(q).beginning_of_day, DateTime.parse(q).end_of_day) if q.present? }
  scope :search_by_description, ->(q) { where("description ilike ?", "%#{q}%") if q.present? }

  searchkick callbacks: :async

  validates :title, presence: true

  def search_data
    {
      title: title,
      author: author,
      publisher: publisher,
      article_date: article_date,
      description: description,
      created_at: created_at
    }
  end

  def full_name
    [author, publisher].reject(&:blank?).join(", ")
  end
end
