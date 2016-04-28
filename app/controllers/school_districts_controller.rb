class SchoolDistrictsController < ApplicationController

  def index
    school_districts = SchoolDistrict.
      where(place_type: params[:type]).
      where('name ilike ?', "%#{params[:q]}%").
      page(params[:page]).per(params[:per_page])
    state = Spree::State.find_by(id: params[:state_id])
    if state
      school_districts = school_districts.where(state_id: state.id)
    end
    render json: {
      items: [{id: '#notListed', text: "#{params[:type]} Not Listed"}] + school_districts.map{|sd| { id: sd.id, text: sd.name_in_option } },
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
