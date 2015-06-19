class Api::UserController < Api::BaseController
  def info
    user = Spree::User.find(doorkeeper_token.resource_owner_id)
    render json: { name: user.full_name, permissions: [] }
  end
end
