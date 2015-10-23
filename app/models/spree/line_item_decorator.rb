Spree::LineItem.class_eval do
  include SalesforceAccess

  def self.sobject_name
    'OrderItem'
  end

  def local_only?
    product.try(:id_in_salesforce).blank?
  end

  def should_create_salesforce?
    return false if order.state != 'complete' || local_only?
    super
  end

  def self.attributes_from_salesforce_object(sfo)
    sfo_data = super(sfo)
    sfo_data.merge!(quantity: sfo.Quantity,
                    price: sfo.UnitPrice)
    sfo_data
  end

  def attributes_for_salesforce
    { 'OrderId' => order.id_in_salesforce,
      'Quantity' => quantity,
      'UnitPrice' => price.to_f,
      'PricebookEntryId' => product.try(:id_in_salesforce),
      'Description' => product.try(:name) }
  end

  # Do not create from salesforce, only try to find a match
  def self.find_or_create_by_salesforce_object(sfo, &_block)
    return nil if sfo.blank?
    matches_salesforce_object(sfo).first
  end
end
