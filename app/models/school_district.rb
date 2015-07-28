# SchoolDistrict
class SchoolDistrict < ActiveRecord::Base
  belongs_to :state, class_name: 'Spree::State'

  enum place_type: { school: 'school', district: 'district' }
end
