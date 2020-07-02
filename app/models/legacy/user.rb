class Legacy::User < ApplicationRecord
  has_many :licenses, class_name: 'Legacy::License', primary_key: :ee_id
end
