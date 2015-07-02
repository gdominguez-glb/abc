module AccountHelper
  def activity_item_link(activity)
    if activity.item_type == 'Page'
      "/#{activity.item.slug}"
    elsif activity.item_type == 'Spree::Product'
      spree.product_path(activity.item.slug)
    end
  end
end
