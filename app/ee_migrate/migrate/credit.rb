module Migrate
  class Credit < ActiveRecord::Base
    establish_connection "#{Rails.env}_migrate"
    self.table_name = 'exp_commoncore_credits'
    self.primary_key = 'id'
  end
end
