class Opportunity < ActiveRecord::Base

  has_many :attachments, class: OpportunityAttachment

  validates :salesforce_id, presence: true
  validate :salesforce_exists?
  validate :validate_attachments?

  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a['file'].blank? }
  attr_accessor :skip_tax_exemption

  private
  def salesforce_exists?
    unless GmSalesforce::Client.instance.find('Opportunity', salesforce_id).present?
      raise
    end
  rescue
    errors[:base] << "This opportunity doesn't exist, please provide a valid opportunity ID"
  end

  def validate_attachments?
    if self.try(:skip_tax_exemption) == "1"
      has_purchase = false
      self.attachments.each do |a|
        has_purchase = true if a.category == "purchase"
      end

      return errors[:base] << "You need to provide purchase order file" unless has_purchase
    else
      return errors[:base] << "You need to attach both files" if self.attachments.to_a.size < 2
    end
  end

end
