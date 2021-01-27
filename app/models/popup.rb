class Popup < ApplicationRecord
  include Orderable

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :available, -> { where('expires_at is null or expires_at > ?', Time.now).where('starts_at is null or starts_at < ?', Time.now) }
end
