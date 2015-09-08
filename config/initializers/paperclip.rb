Paperclip::Storage::S3.class_eval do
  def preview_expiring_url(time = 3600, style_name = default_style)
    if path(style_name)
      base_options = { :expires => time, :secure => use_secure_protocol?(style_name) }
      s3_object(style_name).url_for(:read, base_options.merge(s3_url_options.merge({response_content_disposition: "inline"}))).to_s
    else
      url(style_name)
    end
  end
end
