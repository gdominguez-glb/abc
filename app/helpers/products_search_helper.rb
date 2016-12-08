module ProductsSearchHelper

  def clear_preference_filters
    session[:filter_role] = nil
    session[:filter_curriculum] = nil
  end

end