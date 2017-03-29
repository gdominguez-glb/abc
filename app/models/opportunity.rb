class Opportunity < ActiveRecord::Base

  has_many :attachments, class: OpportunityAttachment

  validates :salesforce_id, presence: true
  validates :po_number, presence: true
  validate :salesforce_exists?
  validate :validate_attachments?

  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a['file'].blank? }
  attr_accessor :skip_tax_exemption, :name, :email, :phone_number

  serialize :data, Hash

  before_create :serialize_data
  after_create :update_po_field

  def sf_account_name
    opportunity_sf_object = GmSalesforce::Client.instance.find('Opportunity', self.salesforce_id)
    sf_account_object = GmSalesforce::Client.instance.find('Account', opportunity_sf_object.AccountId)
    sf_account_object.Name
  rescue
    nil
  end

  private

  def salesforce_exists?
    self.opportunity_id_sf = GmSalesforce::Client.instance.query("select Opp_Id__c from Quote where QuoteNumber = '#{salesforce_id}' and IsSyncing = true").first.try(:Opp_Id__c)
    raise if self.opportunity_id_sf.nil?
  rescue
    errors[:base] << "This opportunity doesn't exist, please provide a valid Quote number"
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

  def serialize_data
    self.data = {name: self.name || "", email: self.email || "", phone_number: self.phone_number || ""}
  end

  def update_po_field
    validation_notes = "Submitted by: #{self.data.try(:[], :name)}\n Email: #{self.data.try(:[], :email)}\n Phone: #{self.data.try(:[], :phone_number)}"

    GmSalesforce::Client.instance.update('Opportunity', {
      'Id' => opportunity_id_sf,
      'PO__c'  => self.po_number,
      "Probability" => 83,
      "StageName" => "Order Under Review",
      "Order_Validation_Notes__c" => validation_notes,
    })
  rescue
    nil
  end

end
