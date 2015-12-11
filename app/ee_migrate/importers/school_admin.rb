module Importers
  class SchoolAdmin
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
