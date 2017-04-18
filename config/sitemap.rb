SitemapGenerator::Sitemap.default_host = 'https://greatminds.org'
SitemapGenerator::Sitemap.create(compress: false) do
  Page.curriculum_nav.each do |curriculum_page|
    add "/#{curriculum_page.slug}"
    curriculum_page.sub_pages.each do |sub_page|
      add "/#{sub_page.slug}"
    end
    if publication = curriculum_page.medium_publications.sorted.first
      add curriculum_blog_path(page_slug: curriculum_page.slug, slug: publication.slug)
    end
    if event_page = curriculum_page.available_event_pages.first
      add curriculum_events_path(page_slug: curriculum_page.slug, slug: event_page.slug)
    end
  end
  Page.by_category('Footer').each do |footer_page|
    add "/#{footer_page.slug}"
  end
  Page.by_category('Enterprise').each do |enterprise_page|
    add "/#{enterprise_page.slug}"
  end

  add '/store'
  spree_routes = Spree::Core::Engine.routes.url_helpers
  Spree::Product.where(individual_sale: true).saleable.unexpire.unarchive.each do |product|
    if product.group_product?
      add spree_routes.group_product_path(product)
    else
      add spree_routes.product_path(product)
    end
  end

  FooterTitle.order('position asc').each do |footer_title|
    if footer_title.link.present?
      add footer_title.link
    end
    footer_title.footer_links.each do |link|
      add link.link
    end
  end

  MediumPublication.displayable.each do |publication|
    publication.posts.find_each do |post|
      if publication.blog_type == 'global'
        add global_post_path(slug: publication.slug, id: post.slug)
      else
        add curriculum_post_path(page_slug: publication.page.slug, slug: publication.slug, id: post.slug)
      end
    end
  end

  Question.displayable.find_each do |question|
    add qa_path(id: question.slug)
  end

  EventPage.global.each do |event_page|
    add events_list_path(slug: event_page.slug)
  end

  add '/contact'
end
