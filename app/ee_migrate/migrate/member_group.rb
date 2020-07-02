module Migrate
  class MemberGroup < ApplicationRecord
    establish_connection "#{Rails.env}_migrate"
    self.table_name = 'exp_member_groups'
    self.primary_key = 'group_id'
  end
end
