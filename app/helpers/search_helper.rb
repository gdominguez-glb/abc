module SearchHelper
  def search_result_partial(item)
    if item.is_a?(Page)
      'page_item'
    elsif item.is_a?(Spree::Product)
      'product_item'
    elsif item.is_a?(Spree::Video)
      'video_item'
    elsif item.is_a?(Spree::Material)
      'material_item'
    end
  end

  def material_link(material)
    product = material.product
    return  "#{product.access_url}?#{{opened_product_id: product.id, opened_material_id: material.id}.to_param}" if product && product.access_url.present?
  end
end
