module Orderable
  extend ActiveSupport::Concern

  included do
    scope :latest, -> { order(created_at: :desc) }
    scope :latest_reverse, -> { order(created_at: :asc) }
  end
end