module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:spree_user]
      user = create(:gm_user); user.spree_roles << Spree::Role.admin; user
      sign_in :spree_user, user
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:spree_user]
      sign_in :spree_user, create(:gm_user)
    end
  end
end
