module VideoGalleryHelper
  include Spree::BaseHelper

  def video_gallery_taxons_tree(root_taxon, current_taxon, max_level = 1)
    return '' if max_level < 1 || root_taxon.leaf?
    content_tag :div, class: 'list-group', style: 'display: none;' do
      root_taxon.children.map do |taxon|
        css_class = (params[:taxon_ids].include?(taxon.id.to_s)) ? 'list-group-item active' : 'list-group-item'
        link_to(taxon.name, params.merge(taxon_ids: params[:taxon_ids] + [taxon.id]), class: css_class) + video_gallery_taxons_tree(taxon, current_taxon, max_level - 1)
      end.join("\n").html_safe
    end
  end
end
