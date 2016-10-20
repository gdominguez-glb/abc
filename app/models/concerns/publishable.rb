module Publishable
  extend ActiveSupport::Concern

  included do
    class_attribute :publish_field_name

    enum publish_status: [ :pending, :published ]
    enum draft_status: [ :draft, :draft_in_progress, :draft_published ]
  end

  def publish!
    publish_attrs = { published_at: Time.now, publish_status: :published, draft_status: :draft_published }
    publish_attrs[self.class.publish_field_name] = send("#{self.class.publish_field_name}_draft")
    update(publish_attrs)
  end

  class_methods do
    def publishable(opts={})
      self.publish_field_name = opts[:name]
    end
  end
end
