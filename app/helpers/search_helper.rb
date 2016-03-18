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
    elsif item.is_a?(Post)
      'post_item'
    end
  end

  def material_link(material)
    product = material.product
    return nil if product.nil?
    return "#{product.access_url}?#{{opened_product_id: product.id, opened_material_id: material.id}.to_param}" if product.access_url.present?
    spree.product_path(product)
  end

  def post_link(post)
    if post.medium_publication.blog_type == 'global'
      global_post_path(slug: post.medium_publication.slug, id: post.id)
    else
      curriculum_post_path(page_slug: post.medium_publication.page.slug, slug: post.medium_publication.slug, id: post.id)
    end
  rescue
    nil
  end
end
