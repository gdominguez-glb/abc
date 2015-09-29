# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  config.allow_guest_checkout   = false
  config.track_inventory_levels = false
  config.always_include_confirm_step = true
end

Spree.user_class = "Spree::User"
Spree::Ability.register_ability(Ability)

Paperclip::Attachment.default_options.merge!({
  storage: :s3,
  bucket: ENV['s3_bucket_name'],
  s3_credentials: {
    access_key_id:     ENV['aws_access_key_id'],
    secret_access_key: ENV['aws_secret_access_key'],
    bucket:            ENV['s3_bucket_name']
  }
})

Paperclip::Attachment.class_eval do
  # monkey patch this method to add callback on file upload
  def after_flush_writes
    unlink_files(@queued_for_write.values)
    if @instance && @instance.respond_to?(:post_flush_writes)
      @instance.post_flush_writes
    end
  end
end

attachment_config = {

  s3_credentials: {
    access_key_id:     ENV['aws_access_key_id'],
    secret_access_key: ENV['aws_secret_access_key'],
    bucket:            ENV['s3_bucket_name']
  },

  storage:        :s3,
  s3_headers:     { "Cache-Control" => "max-age=31557600" },
  s3_protocol:    "http",
  bucket:         ENV['s3_bucket_name'],
  url:            ":s3_domain_url",

  styles: {
      mini:     "48x48>",
      small:    "100x100>",
      product:  "240x240>",
      large:    "600x600>"
  },

  path:           "/:class/:id/:style/:basename.:extension",
  default_url:    "/:class/:id/:style/:basename.:extension",
  default_style:  "product"
}

attachment_config.each do |key, value|
  Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
end

Spree::PermittedAttributes.user_attributes.concat([
  :first_name, :last_name, :address, :interested_subject, :interested_grade_level,
  :school_name, :heard_from, :receive_newsletter, :school_district_id
])

Spree::PermittedAttributes.source_attributes.concat([
  :po_number, :person_to_receive_license
])
