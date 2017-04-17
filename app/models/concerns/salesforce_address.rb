# SalesforceAddress
module SalesforceAddress
  extend ActiveSupport::Concern

  def sf_address(addr, prefix)
    return nil if addr.blank? || !self.class.valid_address_types.member?(prefix)
    # TODO: use this, when supported: [addr.address1, addr.address2].join("\n")
    { "#{prefix}Street" => addr.address1,
      "#{prefix}City" => addr.city,
      "#{prefix}State" => addr.state.try(:abbr),
      "#{prefix}PostalCode" => addr.zipcode,
      "#{prefix}Country" => addr.country.try(:iso)
    }
  end

  class_methods do
    def valid_address_types
      %w(Billing Shipping Mailing Other)
    end

    def address_attributes_valid?(attrs)
      attrs.values_at(:first_name, :last_name, :address1, :city, :country,
                       :zipcode, :phone).all?(&:present?)
    end

    def parse_state_and_country(sfo, type)
      country = Spree::Country.where('iso = :iso or iso3 = :iso', iso: sfo.send("#{type}Country")).first
      state_criteria = { abbr: sfo.send("#{type}State") }
      state_criteria.merge!(country: country) if country.present?
      state = Spree::State.find_by(state_criteria)
      country = state.country if country.blank? && state.present?
      [state, country]
    end

    def parse_phone(sfo)
      phone = sfo.Phone
      phone.blank? ? '000-000-0000' : phone
    end

    def address_attributes(sfo, type)
      return nil if sfo.blank? || !valid_address_types.member?(type)
      state, country = parse_state_and_country(sfo, type)

      attrs = {
        first_name: sfo.FirstName,
        last_name: sfo.LastName,
        phone: parse_phone(sfo),
        address1: sfo.send("#{type}Street"),
        city: sfo.send("#{type}City"),
        state: state,
        zipcode: sfo.send("#{type}PostalCode"),
        country: country
      }

      address_attributes_valid?(attrs) ? attrs : {}
    end
  end
end
