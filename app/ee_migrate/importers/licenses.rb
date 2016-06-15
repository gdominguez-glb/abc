module Importers
  class Licenses

    PRODUCTS_MAPPINGS = YAML.load_file(Rails.root.join('config/data/legacy_products.yml'))['products']

    def self.import(emails=[])
      product_ids = PRODUCTS_MAPPINGS.map {|h| h[:legacy_id]}
      sql = """
        select
           credits.id, credits.member_id, credits.product_id, credits.expiration_date, credits.order_id,
           tokens.first_name, tokens.last_name, tokens.email,
           orders.author_id as author_id, authors.email as author_email
         from exp_commoncore_credits credits
         join exp_commoncore_registration_tokens tokens on tokens.id = credits.token_id
         join exp_channel_titles orders on orders.entry_id = credits.order_id
         join exp_members authors on authors.member_id = orders.author_id
         where
           (credits.expiration_date > '#{Date.today.to_s} 00:00:00' or credits.expiration_date is null)
           and credits.product_id in (:product_ids) #{emails.present? ? "and authors.email in (:emails)" : '' }
      """
      Migrate::Credit.find_by_sql([sql, { emails: emails, product_ids: product_ids }]).each do |credit|
        Legacy::License.create(
          user_id: credit.member_id,
          product_id: credit.product_id,
          expiration_date: credit.expiration_date,
          order_id: credit.order_id,
          first_name: credit.first_name,
          last_name: credit.last_name,
          email: credit.email.try(:downcase),
          from_user_id: credit.author_id,
          from_email: credit.author_email.try(:downcase),
          ee_id: credit.id,
          mapped_name: PRODUCTS_MAPPINGS.find{|m| m[:legacy_id] == credit.product_id }.try(:[], :name)
        )
      end
    end

    def self.import_user_email
      Legacy::License.where(email: nil).where.not(user_id: nil).includes(:user).find_each do |legacy_license|
        legacy_license.update(email: legacy_license.user.try(:email).try(:downcase)) if legacy_license.user.try(:email)
      end
    end
  end
end
