module Importers
  class Licenses

    PRODUCTS_MAPPINGS = YAML.load_file(Rails.root.join('config/data/legacy_products.yml'))['products']

    def self.import(emails=[])
      product_ids = PRODUCTS_MAPPINGS.map {|h| h[:legacy_id]}
      Migrate::Credit.where("expiration_date > ? or expiration_date is null", Date.today).where(product_id: product_ids).each do |credit|
        member = Migrate::Member.find_by(member_id: credit.member_id)
        token = Migrate::RegistrationToken.find_by(id: credit.token_id)
        order = Migrate::ChannelTitle.find_by(entry_id: credit.order_id)
        author = (order ? Migrate::Member.find_by(member_id: order.author_id) : nil

        Legacy::License.create(
          user_id: credit.member_id,
          product_id: credit.product_id,
          expiration_date: credit.expiration_date,
          order_id: credit.order_id,
          first_name: token.try(:first_name),
          last_name: token.try(:last_name),
          email: (member.try(:email).try(:downcase) || token.try(:email)),
          from_user_id: author.try(:member_id),
          from_email: author.try(:email),
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
