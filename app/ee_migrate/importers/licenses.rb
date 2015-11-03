module Importers
  class Licenses

    PRODUCTS_MAPPINGS = YAML.load_file(Rails.root.join('config/data/legacy_products.yml'))['products']

    def self.import
      Migrate::Credit.where("expiration_date > '2015-11-01 00:00:00'").find_each do |credit|
        Legacy::License.create(
          user_id: credit.member_id,
          product_id: credit.product_id,
          expiration_date: credit.expiration_date,
          ee_id: credit.id,
          mapped_name: PRODUCTS_MAPPINGS[credit.product_id]
        )
      end
    end

  end
end
