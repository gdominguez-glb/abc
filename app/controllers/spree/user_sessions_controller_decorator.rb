Spree::UserSessionsController.class_eval do
  def after_sign_in_path_for(resource)
    if resource
      if !resource.admin?
        return_to = session["spree_user_return_to"]
        session["spree_user_return_to"] = nil

        return_to || '/account'
      else
        '/store/admin'
      end
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    URI.parse(request.referer).path if request.referer
  end
end
