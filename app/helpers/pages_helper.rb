module PagesHelper
  def build_footer_social_links(group_page)
    FOOTER_SOCIAL_MEDIA[group_page.try(:group_name)] || FOOTER_SOCIAL_MEDIA["default"]
  end
end
