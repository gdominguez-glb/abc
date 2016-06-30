class Spree::MaterialFile < ActiveRecord::Base
  belongs_to :material, class_name: 'Spree::Material', counter_cache: true

  has_attached_file :file,
    s3_permissions: :private,
    url:            ":s3_alias_url",
    s3_protocol:    "https",
    s3_host_alias:  ENV['s3_bucket_name'],
    s3_headers: { "Content-Disposition" => "attachment" }

  validates_attachment :file, presence: true, content_type: { content_type: /\A*\Z/ }

  def signed_url(expire_in_seconds=3600)
    Aws::CF::Signer.sign_url(self.file.url, expires: (Time.now + expire_in_seconds))
  end

  def preview_signed_url(expire_in_seconds=3600)
    Aws::CF::Signer.sign_url(self.file.url + '?response-content-disposition=inline', expires: (Time.now + expire_in_seconds))
  end
end
