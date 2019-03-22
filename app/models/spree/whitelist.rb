class Spree::Whitelist < ActiveRecord::Base
  belongs_to :school_district

  validates :school_district_id, presence: true

  scope :schools, -> { joins(:school_district).
                     where('school_districts.place_type = ?', 'school') }
  scope :districts, -> { joins(:school_district).
                      where('school_districts.place_type = ?', 'district') }
end
