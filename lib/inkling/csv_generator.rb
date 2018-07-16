module Inkling
  class CsvGenerator
    def self.generate(user, licenses)
      mapping = licenses.inject({}) do |mapping, license|
        mapping[license.product.inkling_id] = (license.quantity > 0 && !license.expired?) ? '1' : '0'
        mapping
      end
      generate_from_user_mapping(user, mapping)
    end

    def self.generate_from_user_mapping(user, mapping)
      product_ids = mapping.keys
      product_values = product_ids.map {|id| mapping[id] }
      headers = ['UserID', 'Username', 'Status', 'FirstName', 'LastName', 'Email'] + product_ids
      CSV.generate(headers: true) do |csv|
        csv << headers
        csv << [
          user.id,
          user.email,
          '1',
          user.first_name,
          user.last_name,
          user.email
        ] + product_values
      end
    end
  end
end
