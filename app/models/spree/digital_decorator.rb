attachment_config = {
  s3_credentials: {
    access_key_id:     ENV['aws_access_key_id'],
    secret_access_key: ENV['aws_secret_access_key'],
    bucket:            ENV['s3_bucket_name']
  },

  storage:        :s3,
  s3_headers:     { "Cache-Control" => "max-age=31557600" },
  s3_protocol:    "https",
  s3_permissions: :private,
  bucket:         ENV['s3_bucket_name'],
  url:            ":s3_domain_url",

  path:           "/:class/:id/:style/:basename.:extension",
  default_url:    "/:class/:id/:style/:basename.:extension"
}

attachment_config.each do |key, value|
  Spree::Digital.attachment_definitions[:attachment][key.to_sym] = value
end

Paperclip::Attachment.class_eval do
  # monkey patch this method to add callback on file upload
  def after_flush_writes
    unlink_files(@queued_for_write.values)
    if @instance && @instance.respond_to?(:post_flush_writes)
      @instance.post_flush_writes
    end
  end
end

Spree::Digital.class_eval do
  def post_flush_writes
    WistiaWorker.perform_async(self.id) if self.wistia_id.blank?
  end
end
