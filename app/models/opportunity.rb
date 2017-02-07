class Opportunity < ActiveRecord::Base

  has_many :attachments, class: OpportunityAttachment

  validates :salesforce_id, presence: true
  validate :salesforce_exists?
  validate :has_attachments?

  accepts_nested_attributes_for :attachments

  private
  def salesforce_exists?
    GmSalesforce::Client.instance.find('Opportunity', salesforce_id).present?
  rescue
    errors[:base] << "This opportunity doesn't exist, please provide a valid opportunity ID"
  end

  def has_attachments?
    errors[:base] << "You need to attach at least one file" if self.attachments.blank?
  end

end
