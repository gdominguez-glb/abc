module PreferenceFilterable
  extend ActiveSupport::Concern

  def filter_by_preferences
    if use_preference_filters?
      apply_preference_filters
    else
      clear_preference_filters
    end
  end

  def apply_preference_filters
    if session[:filter_role].present? && session[:filter_curriculum].present?
      subject_id = find_taxon_by_taxonomy_and_name('Subject', session[:filter_curriculum])
      role_id    = find_taxon_by_taxonomy_and_name('I am a...', session[:filter_role])
      if subject_id || role_id
        params[:taxon_ids] = [subject_id, role_id].compact
      end
    end
  end

  def use_preference_filters?
    params[:taxon_ids].blank? && params[:r].blank?
  end

  def clear_preference_filters
    session[:filter_role] = nil
    session[:filter_curriculum] = nil
  end

  def find_taxon_by_taxonomy_and_name(taxonomy_name, taxon_name)
    Spree::Taxonomy.show_in_store.find_by(name: taxonomy_name).taxons.find_by(name: taxon_name).id
  rescue
    nil
  end

end
