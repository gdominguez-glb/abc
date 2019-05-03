class Api::UserController < Api::BaseController
  def info
    user = Spree::User.find(doorkeeper_token.resource_owner_id)
    render json: {
             user_id: user.id,
             name: user.full_name,
             products: products_of_user(user).as_json(only: [:id, :name])
           }
  end

  def create
    user = Spree::User.find_by email: spree_user_params[:email]
    user = Spree::User.new spree_user_params if user.blank?

    if user.save
      user.accept_terms!

      json_response = {
        id: user.id
      }.to_json

      response_string = {
        spree_user: {
          id: Cypher.encrypt(json_response),
          token: request.headers['HTTP_AUTHORIZATION'].split(' ')[1]
        }
      }

      render json: response_string, status: 201
    else
      render json: { errors: user.errors.full_messages }, status: 500
    end
  end

  private

  def products_of_user(user)
    user.products.map do |product|
      product.parts.exists? ? product.parts : product
    end.flatten.compact.uniq
  end

  def spree_user_params
    params.
      require(:spree_user).
      permit(:first_name, :last_name, :email).
      merge(default_params)
  end

  def default_params
    password = Digest::SHA256.hexdigest rand().to_s

    {
      password: password,
      password_confirmation: password,
      title: 'Mr',
      interested_subjects: ['Math'],
    }
  end
end
