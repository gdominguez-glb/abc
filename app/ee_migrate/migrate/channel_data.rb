module Migrate
  class ChannelData < ActiveRecord::Base
    establish_connection "#{Rails.env}_migrate"
    self.table_name = 'exp_channel_data'
    self.primary_key = 'entry_id'
  end
end
