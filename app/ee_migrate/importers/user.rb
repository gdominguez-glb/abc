module Importers
  class User
    def self.import(emails=[])
      product_ids = Importers::Licenses::PRODUCTS_MAPPINGS.map {|h| h[:legacy_id]}

      member_ids = Migrate::Credit.where("expiration_date > ? or expiration_date is null", Date.today).where(product_id: product_ids).pluck(:member_id).compact.uniq
      members = Migrate::Member.where(member_id: member_ids)

      if emails.present?
        members = members.where('exp_members.email in (?)', emails)
      end

      members.find_each do |member|
        user = Legacy::User.find_or_initialize_by(email: member.email.downcase)
        user.assign_attributes(
          ee_id: member.member_id,
          first_name: member.first_name,
          last_name: member.last_name
        )
        user.save(validate: false)
      end
    end
  end
end
