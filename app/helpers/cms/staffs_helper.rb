module Cms::StaffsHelper
  def staff_type(staff_type: 'staffs')
    if staff_type == 'staffs'
      'Staff'
    elsif staff_type == 'trustees' 
      'Trustee'
    elsif staff_type == 'emeritus_advisors'
      'Emeritus Advisor'
    elsif staff_type == 'pbc_board'
      'PBC Board'
    end
  end
end
