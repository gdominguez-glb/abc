class ContactForm
  include ActiveModel::Model

  attr_accessor :topic, :support_type, :first_name, :last_name, :email, :phone, :role, :school_district_name, :school_district_type,
    :country, :state, :curriculum, :grade, :school_district_size, :title_1, :returning_customer, :tax_exempt, :tax_exempt_id, :desired_dates,
    :desired_training_topic, :items_purchased, :format, :description, :school_district
end
