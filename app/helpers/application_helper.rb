module ApplicationHelper

  def store_active_class
    return '' if request.fullpath !~ /^\/resources/
    return '' if request.fullpath == '/resources/login'
    return '' if request.fullpath == '/resources/signup'
    'active'
  end

  def store_generate_taxon_ids_param(taxon_ids, sibling_ids, taxon)
    selected_taxon_id = (taxon_ids & sibling_ids).first
    if selected_taxon_id
      taxon_ids.delete(selected_taxon_id)
    end
    taxon_ids << taxon.id
  end

  def preview_medium_publication_link(medium_publication)
    if medium_publication.blog_type == 'curriculum'
      main_app.curriculum_blog_path(page_slug: medium_publication.page.slug, slug: medium_publication.slug)
    else
      main_app.global_blog_path(slug: medium_publication.slug)
    end
  end

  def cms_root_for_user(user)
    if user.admin?
      '/cms'
    elsif user.has_vanity_admin_role? || user.has_pd_role?
      '/cms/vanity_urls'
    elsif user.has_hr_role?
      '/cms/jobs'
    end
  end

  def geo_coder(ip)
    Geocoder.search(ip)
  rescue
    nil
  end

  def is_located_in_usa?(ip = nil)
    ip ||= request.ip
    results = geo_coder(ip)
    return results.first.data['country_code'] == 'US' unless results.first.nil?
    true
  end

  def seo_title
    return @seo_title unless @seo_title.nil?

    var = "Great Minds"
    unless @page_title.nil?
      var += " - #{@page_title}"
    end

    var
  end

  def generate_blog_url page_slug, blog_slug
    if page_slug == 'science' || blog_slug == 'witwisdom'
      "#{ENV['HUBSPOT_URL']}/#{blog_slug}"
    else
      "#{ENV['HUBSPOT_URL']}/#{page_slug}/blog/#{blog_slug}"
    end
  end

  def generate_news_url
    "#{ENV['HUBSPOT_URL']}/aha/tag/news-release"
  end

  def generate_webinar_url page
    if page.slug == 'math'
      "#{ENV['HUBSPOT_URL']}/webinar?subject=Math&type=show-all&author=show-all&search"
    elsif page.slug == 'science'
      "#{ENV['HUBSPOT_URL']}/webinar?subject=Science&type=show-all&author=show-all&search=Independent"
    elsif page.slug == 'english'
      "#{ENV['HUBSPOT_URL']}/webinar?subject=English&type=show-all&author=show-all&search="
    end
  end
end
