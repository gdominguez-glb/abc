class SchoolDistrictsController < ApplicationController

  def index
    school_districts = SchoolDistrict.for_selection.
      where(place_type: params[:type]).
      where('name ilike ?', "%#{params[:q]}%").
      page(params[:page]).per(params[:per_page])
    country = Spree::Country.find_by(id: params[:country_id])
    state = Spree::State.find_by(id: params[:state_id])
    if country
      school_districts = school_districts.where(country_id: country.id)
    end
    if state
      school_districts = school_districts.where(state_id: state.id)
    end
    render json: {
      items: school_districts.map{|sd| { id: sd.id, text: sd.name_in_option } },
      total_pages: school_districts.total_pages,
      total_count: school_districts.total_count
    }
  end

  def show
    school_district = SchoolDistrict.find(params[:id])
    render json: {
      item: { id: school_district.id, text: school_district.name_in_option }
    }
  end
end
