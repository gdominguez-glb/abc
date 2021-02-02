module TaxonsFilterHelper
  include Spree::BaseHelper

  def gm_taxons_tree(root_taxon, current_taxon, allow_multiple_taxons_selected)
    ul_class = "dropdown-menu dropdown-ol-menu"

    content_tag :ul, class: ul_class do
      sibling_ids = root_taxon.children.map(&:id)
      root_taxon.children.map do |taxon|
        gm_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected)
      end.join("\n").html_safe
    end
  end

  def gm_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected)
    taxon_selected = params[:taxon_ids].map(&:to_s).include?(taxon.id.to_s)
    if taxon_selected
      generate_selected_taxon_item(taxon)
    else
      generate_normal_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected)
    end
  end

  def generate_selected_taxon_item(taxon)
    content_tag :li, class: "dropdown-ol-item" do
      concat(content_tag(:a, href: remove_taxon_link(taxon), class: "dropdown-ol-link active") do
               concat(taxon.name)
               concat('<i class="mi dropdown-ol-mi">close</i>'.html_safe)
             end)
    end
  end

  def generate_normal_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected)
    taxon_ids = generate_taxon_ids_param(taxon, params[:taxon_ids], sibling_ids, allow_multiple_taxons_selected)
    content_tag :li, class: "dropdown-ol-item" do
      link_to(taxon.name, request.parameters.merge(taxon_ids: taxon_ids),
                class: 'dropdown-ol-link')
    end
  end

  def generate_taxon_ids_param(taxon, taxon_ids, sibling_ids, allow_multiple_taxons_selected)
    return taxon_ids + [taxon.id] if allow_multiple_taxons_selected
    taxon_ids.reject{|_id| sibling_ids.include?(_id.to_i)} + [taxon.id]
  end

  def remove_taxon_link(taxon)
    taxon_ids = params[:taxon_ids].dup.map(&:to_s)
    taxon_ids.delete(taxon.id.to_s)
    url_for(taxon_ids: taxon_ids, r: 1)
  end
end
