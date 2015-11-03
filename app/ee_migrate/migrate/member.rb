module Migrate
  class Member < ActiveRecord::Base
    establish_connection "#{Rails.env}_migrate"
    self.table_name = 'exp_members'
    self.primary_key = 'member_id'
  end
end
