module SearchHelper
  def search_result_partial(item)
    "#{item.class.name.underscore.split('/').last}_item"
  end

  def material_link(material)
    product = material.product
    return nil if product.nil?
    return "#{product.access_url}?#{{opened_product_id: product.id, opened_material_id: material.id}.to_param}" if product.access_url.present?
    spree.product_path(product)
  end

  def post_link(post)
    if post.medium_publication.blog_type == 'global'
      global_post_path(slug: post.medium_publication.slug, id: post.slug)
    else
      curriculum_post_path(page_slug: post.medium_publication.page.slug, slug: post.medium_publication.slug, id: post.slug)
    end
  rescue
    nil
  end

  def event_page_link(event_page)
    if event_page.global?
      events_list_path(slug: event_page.slug)
    elsif event_page.curriculum?
      curriculum_events_path(page_slug: event_page.page.slug, slug: event_page.slug)
    end
  end
end
