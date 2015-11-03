module Migrate
  class Administrator < ActiveRecord::Base
    establish_connection "#{Rails.env}_migrate"
    self.table_name = 'exp_commoncore_administrators'
    self.primary_key = 'id'
  end
end
