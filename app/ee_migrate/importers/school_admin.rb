module Importers
  class SchoolAdmin

    def self.import
      Migrate::Member.find_by_sql("select email from (select authors.email, count(*) as licenses_count from exp_commoncore_credits credits join exp_channel_titles orders on orders.entry_id = credits.order_id join exp_members authors on authors.member_id = orders.author_id  group by authors.email) a where a.licenses_count > 1").find_each do |member|
        user = Legacy::User.find_by(email: member.email)
        user.update(is_school_admin: true) if user
      end
    end

    def self.import_sub_admins
      Migrate::Administrator.where('admin_member_id != 21775').find_each do |administrator|
        admin = Legacy::User.find_by(ee_id: administrator.account_member_id)
        member = Legacy::User.find_by(ee_id: administrator.admin_member_id)
        if admin && admin.is_school_admin && member
          admin.update(is_school_admin: true)
          member.update(is_sub_admin: true, parent_admin_id: admin.id)
        end
      end
    end
  end
end
