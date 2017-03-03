class OpportunityAttachment < ActiveRecord::Base
  include SalesforceAccess

  belongs_to :opportunity
  has_attached_file :file, {
      path:           "/:class/:attachment/:id_partition/:style/:filename",
      url:            ":s3_alias_url",
      s3_protocol:    "https",
      s3_host_alias:  ENV['s3_bucket_name']
  }
  do_not_validate_attachment_file_type :file
  validates_attachment_presence :file

  def self.sobject_name
    'Attachment'
  end

  def attributes_for_salesforce
    {
      'ParentId' => self.opportunity.salesforce_id,
      'Name' => name_for_sf,
      'Description' => name_for_sf,
      'Body' => Base64::encode64(open(self.file.url){|f| f.read})
    }
  end

  def name_for_sf
    return self.file.original_filename if self.category != 'tax'
    "#{self.opportunity.sf_account_name} Sales Tax Exemption Certificate"
  end
end
