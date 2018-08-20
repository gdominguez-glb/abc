class SamlIdpController < SamlIdp::IdpController
  include Spree::AuthenticationHelpers

  def new
    if spree_current_user
      @saml_response = idp_make_saml_response(spree_current_user)
      render :template => "saml_idp/idp/saml_post", :layout => false
      return
    else
      session['spree_user_return_to'] = ENV['INKLING_CONNECT_HOST']
      redirect_to "/resources/login"
    end
  end

  def idp_authenticate(email, password) # not using params intentionally
    user = Spree::User.by_email(email).first
    user && user.valid_password?(password) ? user : nil
  end
  private :idp_authenticate

  def idp_make_saml_response(found_user) # not using params intentionally
    encode_response found_user
  end
  private :idp_make_saml_response

  def logout
    redirect_to '/resources/logout' and return
  end

  def saml_request_id
    nil
  end
end
