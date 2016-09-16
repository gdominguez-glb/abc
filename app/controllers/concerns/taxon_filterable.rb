module TaxonFilterable
  extend ActiveSupport::Concern

  def filter_by_taxons(klass, entities, taxon_ids)
    taxons = Spree::Taxon.where(id: taxon_ids)
    return entities if taxons.blank?
    entity_ids = klass.find_by_sql(generate_intersect_sql(entities, taxons)).map(&:id)
    entities.where(id: entity_ids)
  end

  def generate_intersect_sql(entities, taxons)
    taxons.group_by(&:taxonomy).values.map do |t_taxons|
      "( #{entities.with_taxons(t_taxons).limit(nil).offset(nil).to_sql} )"
    end.join(' INTERSECT ')
  end

end
