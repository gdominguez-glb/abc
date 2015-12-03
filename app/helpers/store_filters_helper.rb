module StoreFiltersHelper
  include Spree::BaseHelper

  def store_filters_taxons_tree(root_taxon, current_taxon, allow_multiple_taxons_selected)
    content_tag :ul, class: 'list-group' do
      sibling_ids = root_taxon.children.map(&:id)
      root_taxon.children.map do |taxon|
        store_filters_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected)
      end.join("\n").html_safe
    end
  end

  def store_filters_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected)
    taxon_selected = params[:taxon_ids].include?(taxon.id.to_s)
    css_class = taxon_selected ? 'list-group-item active' : 'list-group-item'
    if taxon_selected
      content_tag :a, :href => remove_taxon_link(taxon), class: css_class do
        (taxon.name + "<span class='badge badge-danger'><i class='mi'>close</i></span>").html_safe
      end
    else
      taxon_ids = generate_taxon_ids_param(taxon, params[:taxon_ids], sibling_ids, allow_multiple_taxons_selected)
      link_to(taxon.name, params.merge(taxon_ids: taxon_ids), class: css_class)
    end
  end

  def generate_taxon_ids_param(taxon, taxon_ids, sibling_ids, allow_multiple_taxons_selected)
    return taxon_ids + [taxon.id] if allow_multiple_taxons_selected
    taxon_ids.reject{|_id| sibling_ids.include?(_id.to_i)} + [taxon.id]
  end

  def remove_taxon_link(taxon)
    taxon_ids = params[:taxon_ids].dup
    taxon_ids.delete(taxon.id.to_s)
    url_for(taxon_ids: taxon_ids)
  end
end
