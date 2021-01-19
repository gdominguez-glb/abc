module Migrate
  class Credit < ApplicationRecord
    # TODO: Need to create a ticket for to remove the code
    # establish_connection "#{Rails.env}_migrate"
    # self.table_name = 'exp_commoncore_credits'
    # self.primary_key = 'id'
  end
end
