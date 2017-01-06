module ProductRedirectable
  extend ActiveSupport::Concern

  def path_to_redirect_for_product(product)
    if product.product_type == 'inkling'
      main_app.inkling_code_path(product)
    elsif product.library_product?
      main_app.library_path(product)
    elsif product.access_url.present?
      product.parsed_access_url
    end
  end

  def launch_product(product)
    path = path_to_redirect_for_product(product)
    (redirect_to terms_product_path(product) and return) if product.has_license_text? && !current_spree_user.agree_term_of_product?(product)
    redirect_to (path ? path : main_app.root_path)
  end
end