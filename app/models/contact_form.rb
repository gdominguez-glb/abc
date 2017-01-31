class ContactForm
  include ActiveModel::Model

  TOPICS = ["Sales/Purchasing", "Existing Order Support", "Professional Development", "Curriculum Support", "Technical Support", "Parent Support", "Content Error", "General and Other"]
  TOPICS_HASH = TOPICS.inject({}) {|result, topic| result[topic] = topic.gsub(' ', '-').underscore.dasherize.gsub('/', '-'); result }

  ROLES = ["Teacher", "Parent",  "Administrator", "Other"]

  attr_accessor :topic, :first_name, :last_name, :email, :phone, :role, :school_district_name, :school_district_type,
    :country, :state, :curriculum, :grade, :school_district_size, :title_1, :returning_customer, :tax_exempt, :tax_exempt_id, :desired_dates,
    :desired_training_topic, :desired_training_city, :items_purchased, :description, :school_district, :grade_bands, :training_groups_size, :interested_in_hosting_events,
    :related_grade_module_unit_lession

  validates_length_of :first_name, :last_name, :phone, maximum: 40

  validates_presence_of :topic, :first_name, :last_name, :email, :phone
  validates_presence_of :description, if: :require_description?
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def perform
    if ['Sales/Purchasing', 'Professional Development'].include?(self.topic)
      create_lead_object
    elsif ["Existing Order Support", "Curriculum Support", "Technical Support", "Parent Support", "Content Error", "General and Other"].include?(self.topic)
      create_case_object
    end
  end

  def create_lead_object
    attrs = lead_common_attributes
    if self.topic == 'Sales/Purchasing'
      attrs.merge!(sales_attributes)
    elsif self.topic == 'Professional Development'
      attrs.merge!(pd_attributes)
    end
    save_contact_record(attrs)
    ContactWorker.perform_async('Lead', attrs)
  end

  def create_case_object
    attrs = case_common_attributes
    if self.topic == 'General and Other'
      attrs.merge!(general_attributes)
    elsif ["Existing Order Support", "Curriculum Support", "Technical Support", "Parent Support", "Content Error"].include?(self.topic)
      attrs.merge!(support_attributes)
    end
    save_contact_record(attrs)
    ContactWorker.perform_async('Case', attrs)
  end

  def save_contact_record(sf_attrs)
    Contact.create(first_name: first_name, last_name: last_name, topic: topic, message: sf_attrs, email: email)
  end

  def lead_common_attributes
    {
      'FirstName' => self.first_name,
      'LastName' => self.last_name,
      'Title' => self.role,
      'Email' => self.email,
      'Phone' => self.phone,
      'Type__c' => self.school_district_type,
      'Company' => self.school_district_name,
      'Curriculum__c' => self.curriculum
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
      'General__c' => true,
      'General_Details__c' => 'Other',
      'Curriculum__c' => self.curriculum
    }
  end

  def general_attributes
    {
      'State__c' => self.state,
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
      'Curriculum__c' => self.curriculum,
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
      'Curriculum__c' => self.curriculum,
      'Session_Preference__c' => self.desired_training_topic,
      'Desired_Training_City__c' => self.desired_training_city,
      'X1st_Date_Preference__c' => (self.desired_dates.blank? ? nil : self.desired_dates),
      'Grade_Training_Request__c' => (self.grade_bands || []).join(';'),
      'Size_of_Training_Groups__c' => self.training_groups_size,
      'Description' => self.description,
      'Interested_in_hosting_an_open_enrollment__c' => self.interested_in_hosting_events,
      'Request_Date__c'  => Date.today.to_s,
      'RecordTypeId' => lead_pd_request_record_type_id,
      'OwnerId' => pd_lead_queue_id,
      'Comments__c' => self.description
    }
  end

  def lead_pd_request_record_type_id
    RecordType.find_in_salesforce_by_name_and_object_type('PD Request', 'Lead').try('Id')
  end

  def pd_lead_queue_id
    Rails.cache.fetch(:pd_lead_queue_id) do
      GmSalesforce::Client.instance.find_all_in_salesforce('Group', 'Id', "Name='PD Request Lead'").first.Id
    end
  rescue
    nil
  end

  def support_attributes
    {
      'State__c' => self.state,
      'Description' => self.description,
      'Origin' => 'web',
      'Status' => 'New',
      'Priority' => 'Medium',
      'Subject' => self.topic,
      'Related_Grade_Module_Unit_Lesson__c' => self.related_grade_module_unit_lession
    }.merge(support_type_attributes)
  end

  def support_type_attributes
    case self.topic
    when 'Existing Order Support'
      {
        'Curriculum__c' => self.curriculum,
        'Items_Purchased__c' => self.items_purchased,
      }
    when 'Parent Support', 'Technical Support', 'Content Error'
      {
        'Curriculum__c' => self.curriculum,
        'Description' => self.description
      }
    else
      {}
    end
  end

  private

  def require_description?
    ['General and Other', 'Existing Order Support', 'Parent Support', 'Technical Support'].include?(self.topic)
  end
end
