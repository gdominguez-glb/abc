class Api::UserController < Api::BaseController
  def info
    user = Spree::User.find(doorkeeper_token.resource_owner_id)
    render json: {
            user_id: user.id,
            name: user.full_name,
            products: products_of_user(user).
                      as_json(
                        only: [:id, :name, :has_eureka_access]
                      )
           }
  end

  def create
    user = Spree::User.find_by email: spree_user_params[:email]
    user = Spree::User.new spree_user_params if user.blank?

    user.update(spree_user_params)

    if user.save
      user.accept_terms!
      rows = [{ email: user.email, quantity: licensed_products.count }]

      licensed_products.each do |licensed_product|
        unless licensed?(user, licensed_product.product_id)
          Spree::LicensesManager::LicensesDistributer.new(user: admin,
                                                          licensed_products: [licensed_product],
                                                          rows: rows).execute
        end
      end

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

  def product_id
    return Spree::Product.where(id: product_id_param['product_id']).pluck(:id) if product_id_param['product_id'].present?
    [Spree::Product.find_by(name: 'Eureka Navigator LTI').id]
  end

  def licensed?(user, product_id)
    user.products.where(id: product_id).present?
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

  def product_id_param
    params.require(:spree_user)
          .permit(product_id: [])
  end

  def default_params
    password = Digest::SHA256.hexdigest rand().to_s

    {
      password: password,
      password_confirmation: password,
      interested_subjects: ['Math'],
    }
  end

  def licensed_products
    return admin.licensed_products.where(product_id: product_id) unless product_id.empty?
    admin.licensed_products.where(product_id: Spree::Product.find_by(name: 'Eureka Navigator LTI').id)
  end

  def admin
    Spree::User.find_by email: 'web.admin@greatminds.net'
  end
end
