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
end
