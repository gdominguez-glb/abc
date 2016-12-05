module ApplicationHelper
  def store_active_class
    return '' if request.fullpath !~ /^\/store/
    return '' if request.fullpath == '/store/login'
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
    elsif user.has_vanity_admin_role?
      '/cms/vanity_urls'
    elsif user.has_hr_role?
      '/cms/jobs'
    end
  end

  def geo_coder(ip = nil)
    ip = request.ip if ip.nil?
    Geocoder.search(ip)
  end

  def is_located_in_usa?(ip = nil)
    ip = request.ip if ip.nil?
    results = geo_coder(ip)
    return results.first.data['country_code'] == 'US' unless results.first.nil?
    false
  end

end
