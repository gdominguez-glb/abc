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

  def perform
    if ['Print or Bulk Orders', 'Sales and Purchasing', 'Professional Development'].include?(self.topic)
      create_lead_object
    elsif ['General', 'Support'].include?(self.topic)
      create_case_object(self.topic)
    end
  end

  def create_lead_object
    attrs = common_attributes
    if self.topic == 'Sales and Purchasing'
      attrs.merge!(sales_attributes)
    end
    GmSalesforce::Client.instance.create('Lead', attrs)
  end

  def create_case_object(topic)
    attrs = common_attributes
    if topic == 'General'
      attrs.merge!(general_attributes)
    end
    GmSalesforce::Client.instance.create('Case', attrs)
  end

  def common_attributes
    {
      'First_Name__c' => self.first_name,
      'Last_Name__c'  => self.last_name,
      'Role__c'     => self.role,
      'Email__c'     => self.email,
      'Phone__c'     => self.phone,
      'School_District__c' => self.school_district_type,
      'School_District_Name__c' => self.school_district_name,
    }
  end

  def general_attributes
    {
      'Description' => self.description,
      'status' => 'new',
      'Priority' => 'Medium',
      'Subject' => 'General',
      'Origin' => 'web'
    }
  end

  def sales_attributes
    {
      'Country' => 'US',
      'State' => self.state,
      'What_curriculum_are_you_interested_in__c' => self.curriculum,
      'Title_1__c' => self.title_1,
      'Returning_Customer__c' => self.returning_customer,
      'Description' => self.description,
      'Lead_Source' => "Web-Sales"
    }
  end

  private

  def require_description?
    ['General', 'Professional Development'].include?(self.topic) || 
      ( self.topic == 'Support' && ['Order Support', 'Parent Support', 'Content/Implementation Support', 'Technical Support'].include?(self.support_type) )
  end
end
