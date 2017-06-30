module PagesHelper
  def build_footer_social_links(group_page)
    return [] if group_page.nil?

    FOOTER_SOCIAL_MEDIA[group_page.group_name] || []
  end
end
