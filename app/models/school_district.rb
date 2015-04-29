class SchoolDistrict < ActiveRecord::Base
  belongs_to :state, class_name: 'Spree::State'
end
