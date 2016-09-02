module AutocompleteByName
  extend ActiveSupport::Concern

  def autocomplate_by_name(klass, id_name=:id, name_field=:name)
    collection = klass.page(params[:page])

    collection_name = klass.name.split('::').last.underscore.pluralize

    if params[:q]
      collection = collection.where("name ilike ?", "%#{params[:q]}%")
    end

    if params[:name]
      collection = collection.where(name: params[:name])
    end

    render json: {
      count: collection.count,
      total_count: collection.total_count,
      current_page: (params[:page] ? params[:page].to_i : 1),
      per_page: (params[:per_page] || Kaminari.config.default_per_page),
      pages: collection.num_pages,
      collection_name => collection.map{|item| { id: item.send(id_name), name: item.send(name_field) }}
    }
  end
end
