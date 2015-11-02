module Importers
  class SchoolAdmin

    def self.import
      # sql = <<-SQL
      # select  members.email as Admin
      # from exp_commoncore_credits credits
      # join exp_channel_titles orders
      # on entry_id = order_id
      # join exp_members members
      # on members.member_id = orders.author_id
      # group by members.email
      # SQL
      Migrate::Member.select(['exp_members.member_id, exp_members.email']).
        joins("join exp_commoncore_credits on exp_members.member_id = exp_commoncore_credits.member_id").
        joins("join exp_channel_titles on exp_channel_titles.entry_id = exp_commoncore_credits.order_id").
        group("exp_members.email").find_each do |member|
          user = Legacy::User.find_by(email: member.email)
          user.update(is_school_admin: true) if user
        end
    end

  end
end
