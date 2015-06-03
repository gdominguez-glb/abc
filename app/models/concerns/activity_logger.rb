module ActivityLogger
  extend ActiveSupport::Concern
  
  included do
    has_many :activities
  end

  def log_activity(options={})
    self.activities.create(
      title:  options[:title],
      item:   options[:item],
      action: options[:action]
    )
  end
end
