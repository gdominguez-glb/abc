class Cms::ProductsController < Cms::BaseController
  def search
    products = Spree::Product.available.page(params[:page])
    if params[:ids].present?
      products = products.where(id: params[:ids].split(','))
    end
    if params[:q].present?
      products = products.where("name ilike ?", "%#{params[:q]}%")
    end
    render json: {
      products: products.map {|p| { name: p.name, id: p.id }}
    }
  end
end
