module Importers
  class SchoolAdmin

    def self.import
      Migrate::Member.select(['exp_members.member_id, exp_members.email']).
        joins("join exp_commoncore_credits on exp_members.member_id = exp_commoncore_credits.member_id").
        joins("join exp_channel_titles on exp_channel_titles.entry_id = exp_commoncore_credits.order_id").
        group("exp_members.email").find_each do |member|
          user = Legacy::User.find_by(email: member.email)
          user.update(is_school_admin: true) if user
        end
    end

    def self.import_sub_admins
      Migrate::Administrator.where('admin_member_id != 21775').find_each do |administrator|
        admin = Legacy::User.find_by(ee_id: administrator.account_member_id)
        member = Legacy::User.find_by(ee_id: administrator.admin_member_id)
        if admin && admin.is_school_admin && member
          member.update(is_sub_admin: true, parent_admin_id: admin.id)
        end
      end
    end
  end
end
