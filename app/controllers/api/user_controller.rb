class Api::UserController < Api::BaseController
  def info
    user = Spree::User.find(doorkeeper_token.resource_owner_id)
    render json: {
             user_id: user.id,
             name: user.full_name,
             products: products_of_user(user).as_json(only: [:id, :name])
           }
  end

  private

  def products_of_user(user)
    user.products.map do |product|
      product.parts.exists? ? product.parts : product
    end.flatten.compact.uniq
  end
end
