module Cms::StaffsHelper
  def staff_type(staff_type: 'staffs')
    if staff_type == 'staffs'
      'Staff'
    elsif staff_type == 'trustees' 
      'Trustee'
    elsif staff_type == 'emeritus_advisors'
      'Emeritus Advisor'
    end
  end
end
