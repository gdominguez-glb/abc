class RegonlineEvent < ActiveRecord::Base

  geocoded_by :full_address
  after_validation :geocode

  scope :with_filter, ->(filter) { where('client_event_id like ?', "%#{filter}%") }

  def full_address
    [location_name, city, state, country].reject(&:blank?).join(',')
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
