module ApplicationHelper
  def store_active_class
    return '' if request.fullpath !~ /^\/store/
    return '' if request.fullpath == '/store/login'
    'active'
  end

  def product_image_url(product, style = 'large')
    image = product.variant_images.first
    image ? image.attachment.url(style) : "/assets/noimage/#{style}.png"
  end
end
