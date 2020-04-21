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

    admin = Spree::User.find_by email: 'web.admin@greatminds.net'
    licensed_products = admin.licensed_products.where(product_id: navigator_product_id)

    if user.save
      user.accept_terms!
      rows = [{ email: user.email, quantity: '1' }]

      Spree::LicensesManager::LicensesDistributer.new(user: admin,
                                                      licensed_products: licensed_products,
                                                      rows: rows).execute unless licensed?(user)

      json_response = {
        id: user.id,
        token: request.headers['HTTP_AUTHORIZATION'].split(' ')[1],
        school_district: user.school_district.name,
        school_district_id: user.school_district.id
      }.to_json

      response_string = {
        spree_user: {
          id: Cypher.encrypt(json_response)
        }
      }

      render json: response_string, status: 201
    else
      render json: { errors: user.errors.full_messages }, status: 500
    end
  end

  private

  def navigator_product_id
    Spree::Product.find_by(name: 'Eureka Navigator LTI').id
  end

  def licensed?(user)
    products_of_user(user).map(&:id).include?(navigator_product_id)
  end

  def products_of_user(user)
    user.products.map do |product|
      product.parts.exists? ? product.parts : product
    end.flatten.compact.uniq
  end

  def spree_user_params
    params.require(:spree_user)
          .permit(:first_name, :last_name, :email, :title, :school_district_id)
          .merge(default_params)
  end

  def default_params
    password = Digest::SHA256.hexdigest rand().to_s

    {
      password: password,
      password_confirmation: password,
      interested_subjects: ['Math'],
    }
  end
end
