module ApplicationHelper
  def store_active_class
    return '' if request.fullpath !~ /^\/store/
    return '' if request.fullpath == '/store/login'
    'active'
  end
end
