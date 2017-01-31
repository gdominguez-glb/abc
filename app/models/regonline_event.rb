class RegonlineEvent < ActiveRecord::Base

  include Displayable

  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.full_address_changed? }

  serialize :session_types, Array

  scope :with_filter, ->(filter) { where('client_event_id ilike ?', "%#{filter}%") }
  scope :sorted, -> { order('start_date asc') }

  FILTER_GRADE_BANDS = ["PK", "K-2", "3-5", "6-8", "9-12"].freeze

  def full_address
    [location_name, city, state, country].reject(&:blank?).join(',')
  end

  def full_address_changed?
    [:location_name, :city, :state, :country].map {|f| self.send("#{f}_changed?") }.any?
  end

  def to_partial_path
    'events/event'
  end

  def training_type
    @training_type ||= begin
      self.client_event_id.split(',')[1] rescue nil
    end
  end

  def event_trainings
    EventTraining.where(id: self.session_types)
  end

  def text_to_index
    [title, city, state, country, postal_code, location_address1, location_address2, client_event_id].compact.join(' ')
  end

  class << self
    ATTRIBUTES_TO_IMPORT = ["ID", "Title", "StartDate", "EndDate", "ActiveDate", "City", "State", "Country", "PostalCode", "LocationName", "LocationRoom", "LocationBuilding", "LocationAddress1", "LocationAddress2", "Latitude", "Longitude", "ClientEventID"]
    def import(data)
      attrs = convert_data_to_attributes(data)
      event = RegonlineEvent.find_or_initialize_by(regonline_id: data['ID'])
      event.update(attrs)
    end

    def convert_data_to_attributes(data)
      ATTRIBUTES_TO_IMPORT.inject({}) do |attrs, reg_attr_name|
        attr_name = reg_attr_name == 'ID' ? 'regonline_id' : reg_attr_name.underscore
        attrs[attr_name] = data[reg_attr_name]
        attrs
      end
    end
  end
end
