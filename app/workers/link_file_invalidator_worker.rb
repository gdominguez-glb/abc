require 'cloudfront_invalidator'
class LinkFileInvalidatorWorker
  include Sidekiq::Worker

  def perform(link_file_id)
    link_file = LinkFile.find(link_file_id)
    identifier = "link_file_#{link_file.id}_#{link_file.updated_at.to_i}"
    CloudfrontInvalidator.new(link_file.file.path, identifier).invalidate!
  end
end
