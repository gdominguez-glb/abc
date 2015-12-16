module Importers
  class SchoolAdmin

    def self.import
      emails = Legacy::License.find_by_sql("select from_email, product_id, count(*) as licenses_count  from legacy_licenses where from_email != email group by from_email, product_id").map(&:from_email)
      Legacy::User.where(email: emails).update_all(is_school_admin: true)
    end

    def self.import_sub_admins
      Migrate::Administrator.where('admin_member_id != 21775').find_each do |administrator|
        admin = Legacy::User.find_by(ee_id: administrator.account_member_id)
        member = Legacy::User.find_by(ee_id: administrator.admin_member_id)
        if admin && member
          admin.update(is_school_admin: true)
          member.update(is_sub_admin: true, parent_admin_id: admin.id)
        end
      end
    end
  end
end
