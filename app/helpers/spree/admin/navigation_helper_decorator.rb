Spree::Admin::NavigationHelper.class_eval do

  def main_part_classes
    if cookies['sidebar-minimized'] == 'true'
      return 'col-sm-12 col-md-12'
    else
      return 'col-sm-9 col-md-10'
    end
  end

end
