module Importers
  class Licenses

    PRODUCTS_MAPPINGS = YAML.load_file(Rails.root.join('config/data/legacy_products.yml'))['products']

    def self.import
      Migrate::Credit.joins("join exp_commoncore_registration_tokens on exp_commoncore_registration_tokens.id = exp_commoncore_credits.token_id").
        select('exp_commoncore_credits.*, exp_commoncore_registration_tokens.email, exp_commoncore_registration_tokens.first_name, exp_commoncore_registration_tokens.last_name').
        where("expiration_date > '2015-11-01 00:00:00'").find_each do |credit|
        Legacy::License.create(
          user_id: credit.member_id,
          product_id: credit.product_id,
          expiration_date: credit.expiration_date,
          order_id: credit.order_id,
          first_name: credit.first_name,
          last_name: credit.last_name,
          email: credit.email,
          ee_id: credit.id,
          mapped_name: PRODUCTS_MAPPINGS[credit.product_id]
        )
      end
    end

  end
end
