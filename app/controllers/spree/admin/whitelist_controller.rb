class Spree::Admin::WhitelistController < Spree::Admin::BaseController
  before_action :set_whitelist, only: [:destroy]
  before_action :set_vars, only: [:index, :create]

  def index
    @whitelist = Spree::Whitelist.new
  end

  def create
    @whitelist = Spree::Whitelist.new whitelist_params

    if @whitelist.save
      redirect_to action: 'index'
    else
      render 'index'
    end
  end

  def destroy
    @whitelist.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to admin_whitelist_index_path  }
    end
  end

  private

  def country_list
    countries = Spree::Country.order(:name).to_a
    us_index = countries.index {|country| country[:iso] == "US"}
    countries.insert(0, countries.delete_at(us_index))
  end

  def whitelist_params
    params.require(:whitelist).permit(:school_district_id)
  end

  def set_whitelist
    @whitelist = Spree::Whitelist.find params[:id]
  end

  def set_vars
    @country_list = country_list.map do |country|
      [country.name, country.id]
    end

    @us_states_list = Spree::Country.find_by(iso: 'US').states.map do |state|
      [state.name, state.id]
    end

    @school_whitelist = Spree::Whitelist.schools
    @district_whitelist = Spree::Whitelist.districts
  end
end
