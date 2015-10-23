class ContactForm
  include ActiveModel::Model

  TOPICS = ["General", "Print or Bulk Orders", "Sales and Purchasing", "Professional Development", "Support"]
  SUPPORT_TYPES = ["Order Support", "Parent Support", "Content/Implementation Support", "Content Error", "Technical Support"]

  attr_accessor :topic, :support_type, :first_name, :last_name, :email, :phone, :role, :school_district_name, :school_district_type,
    :country, :state, :curriculum, :grade, :school_district_size, :title_1, :returning_customer, :tax_exempt, :tax_exempt_id, :desired_dates,
    :desired_training_topic, :items_purchased, :format, :description, :school_district

  validates_presence_of :first_name, :last_name, :email, :phone
  validates_presence_of :description, if: :require_description?
  validates_presence_of :format, if: ->{ self.support_type == 'Content Error' }

  def require_description?
    ['General', 'Professional Development'].include?(self.topic) || 
      ( self.topic == 'Support' && ['Order Support', 'Parent Support', 'Content/Implementation Support', 'Technical Support'].include?(self.support_type) )
  end
end
