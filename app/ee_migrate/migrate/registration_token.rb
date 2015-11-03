module Migrate
  class RegistrationToken < ActiveRecord::Base
    establish_connection "#{Rails.env}_migrate"
    self.table_name = 'exp_commoncore_registration_tokens'
    self.primary_key = 'id'
  end
end
