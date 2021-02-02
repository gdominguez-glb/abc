module Migrate
  class Member < ApplicationRecord
    # TODO: Need to create a ticket for to remove the code
    # establish_connection "#{Rails.env}_migrate"
    # self.table_name = 'exp_members'
    # self.primary_key = 'member_id'
  end
end
