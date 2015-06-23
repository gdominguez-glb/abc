class RegonlineEvent < ActiveRecord::Base

  reverse_geocoded_by :latitude, :longitude

  class << self
    ATTRIBUTES_TO_IMPORT = ["ID", "Title", "StartDate", "EndDate", "ActiveDate", "City", "State", "Country", "PostalCode", "LocationName", "LocationRoom", "LocationBuilding", "LocationAddress1", "LocationAddress2", "Latitude", "Longitude"]
    def import(data)
      attrs = convert_data_to_attributes(data)
      event = RegonlineEvent.find_or_initialize_by(regonline_id: data['regonline_id'])
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
