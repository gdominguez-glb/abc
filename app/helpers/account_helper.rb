module AccountHelper
  def activity_item_link(activity)
    return '' if activity.item.blank?

    case activity.item_type
    when 'Page'
      generate_page_activity_url(activity)
    when 'Spree::Product'
      generate_product_activity_url(activity)
    when 'Spree::Material'
      generate_material_activity_url(activity)
    end
  end

  def generate_page_activity_url(activity)
    "/#{activity.item.slug}"
  end

  def generate_product_activity_url(activity)
    if activity.action == 'download'
      "#{activity.item.access_url}?#{{opened_product_id: activity.item.id}.to_param}"
    else
      spree.product_path(activity.item.slug)
    end
  end

  def generate_material_activity_url(activity)
    product = activity.item.product
    return '' if product.blank?
    "#{product.access_url}?#{{opened_product_id: product.id, opened_material_id: activity.item.id}.to_param}"
  end
end
