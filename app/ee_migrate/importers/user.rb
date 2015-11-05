module Importers
  class User
    def self.import
      sql = <<-SQL
        SELECT 
          *
        FROM 
          exp_members 
        LEFT JOIN
          exp_member_data ON exp_members.member_id = exp_member_data.member_id
        LEFT JOIN 
          exp_channel_titles ON exp_channel_titles.author_id = exp_members.member_id
        LEFT JOIN 
          exp_channel_data ON exp_channel_titles.entry_id = exp_channel_data.entry_id group by exp_members.member_id limit 100
      SQL
      Migrate::Member.select([
        'exp_members.member_id',
        'exp_members.group_id',
        'exp_members.email',
        'exp_channel_data.field_id_158 as first_name',
        'exp_channel_data.field_id_158 as last_name'
      ]).joins("left join exp_member_data ON exp_members.member_id = exp_member_data.member_id")
        .joins("left join exp_channel_titles ON exp_channel_titles.author_id = exp_members.member_id")
        .joins("left join exp_channel_data ON exp_channel_titles.entry_id = exp_channel_data.entry_id")
        .group("exp_members.member_id").find_each do |member|
          user = Legacy::User.find_or_initialize_by(email: member.email)
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