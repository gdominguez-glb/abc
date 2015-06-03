Devise.secret_key = "4c9e66e1cb88f2934990b18c15fd233ab824022a85fd9b4f59a7396d85d31b7ff90d07eab0aa23d25c55f620af2c2184a43e"

Warden::Manager.after_authentication do |user,auth,opts|
  user.log_acitivity(
    item: user,
    title: 'Login',
    action: 'login'
  )
end
Warden::Manager.prepend_before_logout do |user,auth,opts|
  if user
    user.log_acitivity(
      item: user,
      title: 'Logout',
      action: 'logout'
    )
  end
end
