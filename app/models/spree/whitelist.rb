class Spree::Whitelist < ApplicationRecord
  belongs_to :school_district

  validates :school_district_id, presence: true

  scope :schools, -> { joins(:school_district).
                     where('school_districts.place_type = ?', 'school') }
  scope :districts, -> { joins(:school_district).
                      where('school_districts.place_type = ?', 'district') }

  def self.skip_terms?(user: nil)
    !where(school_district_id: user.school_district.id).empty?
  end
end
