module Migrate
  class ChannelTitle < ActiveRecord::Base
    establish_connection "#{Rails.env}_migrate"
    self.table_name = 'exp_channel_titles'
    self.primary_key = 'entry_id'
  end
end
