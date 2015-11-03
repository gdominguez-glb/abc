class Legacy::User < ActiveRecord::Base
  has_many :licenses, class_name: 'Legacy::License', primary_key: :ee_id
end
