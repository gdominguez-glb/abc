Spree::User.class_eval do
  validates_presence_of :first_name, :last_name, :school_district

  # add any other characters you'd like to disallow inside the [ brackets ]
  # metacharacters [, \, ^, $, ., |, ?, *, +, (, and ) need to be escaped with a \
  validates_format_of :first_name, :last_name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/

  belongs_to :school_district

  accepts_nested_attributes_for :school_district, reject_if: proc { |attributes| attributes['name'].blank? }

  def name
    "#{first_name} #{last_name}"
  end

  def name=(new_name)
    self.first_name = new_name.split(' ').first
    self.last_name = new_name.split(' ').last
  end
end
