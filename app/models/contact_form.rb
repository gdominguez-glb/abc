class ContactForm
  include ActiveModel::Model

  TOPICS = ["General", "Print or Bulk Orders", "Sales and Purchasing", "Professional Development", "Support"]
  SUPPORT_TYPES = ["Order Support", "Parent Support", "Content/Implementation Support", "Content Error", "Technical Support"]

  attr_accessor :topic, :support_type, :first_name, :last_name, :email, :phone, :role, :school_district_name, :school_district_type,
    :country, :state, :curriculum, :grade, :school_district_size, :title_1, :returning_customer, :tax_exempt, :tax_exempt_id, :desired_dates,
    :desired_training_topic, :items_purchased, :format, :description, :school_district, :grade_bands, :training_groups_size, :interested_in_hosting_events

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
    attrs = lead_common_attributes
    if self.topic == 'Sales and Purchasing'
      attrs.merge!(sales_attributes)
    elsif self.topic == 'Professional Development'
      attrs.merge!(pd_attributes)
    end
    GmSalesforce::Client.instance.create('Lead', attrs)
  end

  def create_case_object(topic)
    attrs = case_common_attributes
    if topic == 'General'
      attrs.merge!(general_attributes)
    elsif topic == 'Support'
      attrs.merge!(support_attributes)
    end
    GmSalesforce::Client.instance.create('Case', attrs)
  end

  def lead_common_attributes
    {
      'FirstName' => self.first_name,
      'LastName' => self.last_name,
      'Title' => self.role,
      'Email' => self.email,
      'Phone' => self.phone,
      'Type__c' => self.school_district_type,
      'Company' => self.school_district
    }
  end

  def case_common_attributes
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
      'LeadSource' => "Web-Sales"
    }
  end

  def pd_attributes
    {
      'Country' => 'US',
      'State' => self.state,
      'What_curriculum_are_you_interested_in__c' => self.curriculum,
      'Session_Preference__c' => self.desired_training_topic,
      'X1st_Date_Preference__c' => self.desired_dates,
      'Grade_Training_Request__c' => self.grade_bands,
      'Size_of_Training_Groups__c' => self.training_groups_size,
      'Description' => self.description,
      'Intrested_in_hosting_an_open_enrollment__c' => self.interested_in_hosting_events,
      'Request_Date__c'  => Date.today.to_s,
      'RecordTypeId' => lead_pd_request_record_type_id
    }
  end

  def lead_pd_request_record_type_id
    RecordType.find_in_salesforce_by_name_and_object_type('PD Request', 'Lead').try('Id')
  end

  def support_attributes
    {
      'Description' => self.description,
      'Origin' => 'web',
      'Status' => 'New',
      'Priority' => 'Medium',
      'Subject' => self.support_type
    }.merge(support_type_attributes)
  end

  def support_type_attributes
    case self.support_type
    when 'Order Support'
      {
        'What_curriculum_are_you_interested_in__c' => self.curriculum,
        'Items_Purchased__c' => self.items_purchased,
      }
    when 'Parent Support', 'Content/Implementation Support'
      {
        'What_curriculum_are_you_interested_in__c' => self.curriculum,
      }
    when 'Content Error'
      {
        'What_curriculum_are_you_interested_in__c' => self.curriculum,
        'Format' => self.format
      }
    else
      {}
    end
  end

  private

  def require_description?
    ['General', 'Professional Development'].include?(self.topic) || 
      ( self.topic == 'Support' && ['Order Support', 'Parent Support', 'Content/Implementation Support', 'Technical Support'].include?(self.support_type) )
  end
end
