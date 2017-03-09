module TaxonsFilterHelper
  include Spree::BaseHelper

  def gm_taxons_tree(root_taxon, current_taxon, allow_multiple_taxons_selected, feature_flipper = nil)
    # TODO After removing $flipper feature, we need to remove the feature_flipper = nil parameter in each method
    # TODO Also, we need to remove the extra parameter in app/views/video_gallery/_taxonomies.html.erb & _taxonomies_new.html.erb
    feature_flipper ||= :store_redesign

    if $flipper[feature_flipper].enabled?
      ul_class = "dropdown-menu dropdown-ol-menu"
    else
      ul_class = "list-group"
    end

    content_tag :ul, class: ul_class do
      sibling_ids = root_taxon.children.map(&:id)
      root_taxon.children.map do |taxon|
        gm_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected, feature_flipper)
      end.join("\n").html_safe
    end
  end

  def gm_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected, feature_flipper)
    taxon_selected = params[:taxon_ids].map(&:to_s).include?(taxon.id.to_s)
    if taxon_selected
      generate_selected_taxon_item(taxon, feature_flipper)
    else
      generate_normal_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected, feature_flipper)
    end
  end

  def generate_selected_taxon_item(taxon, feature_flipper)
    if $flipper[feature_flipper].enabled?
      content_tag :li, class: "dropdown-ol-item" do
        concat(content_tag(:a, href: remove_taxon_link(taxon), class: "dropdown-ol-link active") do
                 concat(taxon.name)
                 concat('<i class="mi dropdown-ol-mi">close</i>'.html_safe)
        end)
      end
    else
      content_tag :a, :href => remove_taxon_link(taxon), class: 'list-group-item active' do
        ("<span class='panel-filter-text'>#{taxon.name}</span> <span class='filter-remove'><i class='mi'>close</i></span>").html_safe
      end
    end
  end

  def generate_normal_taxon_item(taxon, sibling_ids, allow_multiple_taxons_selected, feature_flipper)
    taxon_ids = generate_taxon_ids_param(taxon, params[:taxon_ids], sibling_ids, allow_multiple_taxons_selected)
    if $flipper[feature_flipper].enabled?
      content_tag :li, class: "dropdown-ol-item" do
        link_to(taxon.name, params.merge(taxon_ids: taxon_ids), class: 'dropdown-ol-link')
      end
    else
      link_to(taxon.name, params.merge(taxon_ids: taxon_ids), class: 'list-group-item')
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
