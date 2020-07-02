module Migrate
  class Administrator < ApplicationRecord
    establish_connection "#{Rails.env}_migrate"
    self.table_name = 'exp_commoncore_administrators'
    self.primary_key = 'id'
  end
end
