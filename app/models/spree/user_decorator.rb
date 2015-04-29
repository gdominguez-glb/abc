Spree::User.class_eval do
  validates_presence_of :first_name, :last_name, :school_district

  belongs_to :school_district

  accepts_nested_attributes_for :school_district, reject_if: proc { |attributes| attributes['name'].blank? } end
