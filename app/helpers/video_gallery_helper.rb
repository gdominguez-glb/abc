module VideoGalleryHelper
  include Spree::BaseHelper

  def video_gallery_taxons_tree(root_taxon, current_taxon, allow_multiple_taxons_selected)
    content_tag :div, class: 'list-group', style: 'display: none;' do
      sibling_ids = root_taxon.children.map(&:id)
      root_taxon.children.map do |taxon|
        video_gallery_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected)
      end.join("\n").html_safe
    end
  end

  def video_gallery_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected)
    css_class = (params[:taxon_ids].include?(taxon.id.to_s)) ? 'list-group-item active' : 'list-group-item'
    taxon_ids = generate_taxon_ids_param(taxon, params[:taxon_ids], sibling_ids, allow_multiple_taxons_selected)
    link_to(taxon.name, params.merge(taxon_ids: taxon_ids), class: css_class)
  end

  def generate_taxon_ids_param(taxon, taxon_ids, sibling_ids, allow_multiple_taxons_selected)
    return taxon_ids + [taxon.id] if allow_multiple_taxons_selected
    taxon_ids.reject{|_id| sibling_ids.include?(_id.to_i)} + [taxon.id]
  end
end
