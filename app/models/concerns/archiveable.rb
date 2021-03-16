module Archiveable
  extend ActiveSupport::Concern

  included do
    scope :archived, ->{ where(archived: true) }
    scope :unarchive, ->{ where(archived: false) }
  end

  def archive!
    update(archived: true, archived_at: Time.now, slug: slug + '-old-' + SecureRandom.hex(3))
  end

  def unarchive!
    update(archived: false, archived_at: nil, publish_status: :pending, draft_status: :draft, slug:
      slug.split(/-old-(?=[^-old-][0-9a-zA-Z_])/).try(:first))
  end
end
