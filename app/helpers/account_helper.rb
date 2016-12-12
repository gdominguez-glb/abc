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
    product_material_link(activity.item)
  end

  def product_material_link(material)
    product = material.product
    return '' if product.blank?
    "#{product.access_url}?#{{opened_product_id: product.id, opened_material_id: material.id}.to_param}"
  end

  def bookmark_item_url(item)
    if item.is_a?(Spree::Video)
      video_gallery_path(item)
    elsif item.is_a?(Spree::Material)
      product_material_link(item)
    end
  end

  def cms_display_status(item)
    if item.archived?
      'archived'
    elsif item.draft_status === 'draft_published'
      'published'
    elsif item.draft_status === 'draft_in_progress'
      'in progress'
    else
      'draft'
    end
  end
end
