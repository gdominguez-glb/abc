module Migrate
  class ChannelTitle < ApplicationRecord
    establish_connection "#{Rails.env}_migrate"
    self.table_name = 'exp_channel_titles'
    self.primary_key = 'entry_id'

    belongs_to :author, class_name: 'Legacy::User', primary_key: :ee_id
  end
end
