module AccountHelper
  def activity_item_link(activity)
    return '' if activity.item.blank?
    if activity.item_type == 'Page'
      "/#{activity.item.slug}"
    elsif activity.item_type == 'Spree::Product'
      if activity.action == 'download'
        "#{activity.item.access_url}?#{{opened_product_id: activity.item.id}.to_param}"
      else
        spree.product_path(activity.item.slug)
      end
    elsif activity.item_type == 'Spree::Material'
      product = activity.item.product
      "#{product.access_url}?#{{opened_product_id: product.id, opened_material_id: activity.item.id}.to_param}"
    end
  end
end
