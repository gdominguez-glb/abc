class Cms::UsersController < Cms::BaseController
  def search
    users = Spree::User.page(params[:page])
    if params[:q].present?
      users = users.where("email ilike ?", "%#{params[:q]}%")
    end
    render json: {
      users: users.map {|p| { email: p.email, id: p.id }}
    }
  end
end
