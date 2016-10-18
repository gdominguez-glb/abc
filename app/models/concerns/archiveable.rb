module Archiveable
  extend ActiveSupport::Concern

  included do
    scope :archived, ->{ where(archived: true) }
    scope :unarchive, ->{ where(archived: false) }
  end

  def archive!
    update(archived: true, archived_at: Time.now)
  end

  def unarchive!
    update(archived: false, archived_at: nil)
  end
end
