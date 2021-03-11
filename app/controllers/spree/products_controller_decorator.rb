Spree::ProductsController.class_eval do
  include ProductTaxonsFilter, ProductRedirectable

  before_action :authenticate_user!, only: %i[launch terms agree_terms]
  before_action :find_launch_product, only: %i[launch terms agree_terms inkling]
  before_action :accepted_updated_terms

  def index
    @products = products_list_with_taxons_filter
  end

  def launch
    launch_product(@product)
  end

  def terms
  end

  def agree_terms
    current_spree_user.product_agreements.find_or_create_by(product: @product)
    redirect_to launch_product_path(@product)
  end

  def get_curriculum_name(id = nil)
    Curriculum.where(id: id).try(:first).try(:name) ? Curriculum.where(id: id).first.name + ' | ' : ''
  end

  def group
    @product_group = Spree::Product.publicable.find_by(slug: params[:id])

    if @product_group.blank?
      redirect_to not_found_path and return
    end

    # This will display the seo title as 'Great Minds Resources | Math | Eureka Math' for all products of the type 'group'
    @seo_title = 'Great Minds Resources | ' + get_curriculum_name(@product_group.try(:curriculum_id)) + @product_group.try(:name)
    @products = @product_group.group_items
                              .unexpire
                              .unarchive
                              .order('spree_group_items.created_at asc')
  end

  def show
    @product = @products.publicable.friendly.find(params[:id])

    if @product.archived?
      redirect_to main_app.not_found_path and return
    end

    if @product.group_product?
      redirect_to spree.group_product_path(@product) and return
    end

    @variants = @product.variants_including_master
                        .active(current_currency)
                        .includes(%i[option_values images])
    @product_properties = @product.product_properties.includes(:property)
    @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
  end

  helper_method :saml_acs_url

  include SamlIdp::Controller

  def inkling
    @saml_response =
      encode_response(spree_current_user, audience_uri: saml_audience_url,
                                          issuer_uri: "#{request.base_url}/saml/auth")

    render template: 'saml_idp/idp/saml_post', layout: false
    return
  end

  def saml_acs_url
    'https://api.inkling.com/saml/v2/acs/e3151cc5af6f491889865b7c408b0525'
  end

  def saml_audience_url
    'https://api.inkling.com/saml/v2/metadata/e3151cc5af6f491889865b7c408b0525'
  end

  def saml_request_id
    nil
  end

  private

  def find_launch_product
    @product = current_spree_user.products.find_by(slug: params[:id]) ||
               current_spree_user.part_products.find_by(slug: params[:id])

    if @product.blank?
      flash[:error] = 'This product is currently inactive. You will have access on your fulfillment date. If you have any questions, please contact us.'
      redirect_to main_app.account_products_path
      return
    end
  end
end
