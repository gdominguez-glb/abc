class VanityUrl < ActiveRecord::Base
  validates :url, presence: true, url: true
  validates :redirect_url, presence: true, url: true

  scope :search_url, ->(q) {
    where("url like :q or redirect_url like :q", q: "%#{q}%")
  }

  acts_as_taggable
end
