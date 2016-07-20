module Importers
  class Licenses

    PRODUCTS_MAPPINGS = YAML.load_file(Rails.root.join('config/data/legacy_products.yml'))['products']

    def self.import(emails=[])
      product_ids = PRODUCTS_MAPPINGS.map {|h| h[:legacy_id]}
      order_ids_left_to_migrate = Importers::Licenses.order_ids_left_to_migrate
      Migrate::Credit.where(order_id: order_ids_left_to_migrate).
        where("expiration_date >= ? or expiration_date is null", Date.new(2016, 6, 30)).
        where(product_id: product_ids).each do |credit|

          next if Legacy::License.find_by(ee_id: credit.ee_id)

          member = Migrate::Member.find_by(member_id: credit.member_id)
          token = Migrate::RegistrationToken.find_by(id: credit.token_id)
          order = Migrate::ChannelTitle.find_by(entry_id: credit.order_id)
          author = (order ? Migrate::Member.find_by(member_id: order.author_id) : nil)

          Legacy::License.create(
            user_id: credit.member_id,
            product_id: credit.product_id,
            expiration_date: credit.expiration_date,
            order_id: credit.order_id,
            first_name: token.try(:first_name),
            last_name: token.try(:last_name),
            email: (member.try(:email).try(:downcase) || token.try(:email).try(:downcase)),
            from_user_id: author.try(:member_id),
            from_email: author.try(:email).try(:downcase),
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

    def self.order_ids_left_to_migrate
      product_ids = PRODUCTS_MAPPINGS.map {|h| h[:legacy_id]}
      entry_date = Date.new(2015, 8, 1).beginning_of_day.to_i
      sql = <<-SQL
        select distinct(exp_commoncore_credits.order_id) from exp_commoncore_credits
        join exp_channel_titles on exp_channel_titles.entry_id = exp_commoncore_credits.order_id
        where exp_commoncore_credits.expiration_date >=  '2016-06-30' and product_id in (#{product_ids.join(',')})
        and exp_channel_titles.entry_date > #{entry_date}
      SQL
      order_ids = Migrate::ChannelTitle.find_by_sql(sql).map(&:order_id)
      order_ids - Legacy::License.where(order_id: order_ids).pluck(:order_id).uniq
    end
  end
end
