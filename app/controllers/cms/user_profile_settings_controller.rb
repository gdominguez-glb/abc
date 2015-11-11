class Cms::UserProfileSettingsController < Cms::BaseController
  def index
    load_fields
  end

  def save
    AppSettings.user_profile_settings = settings_params
    redirect_to '/cms/user_profile_settings'
  end

  private

  def settings_params
    load_fields
    _params = params.require(:app).permit(admin: (@basic_fields + @profile_fields), school_district_admin: (@basic_fields + @profile_fields), user: (@basic_fields + @profile_fields))
    _params = _params.to_hash.deep_symbolize_keys
    _params.each do |k, v|
      v.each do |_k, _v|
        _params[k][_k] = (_v == 'true' ? true : false)
      end
    end
    _params
  end

  def load_fields
    @basic_fields   = [:first_name, :last_name, :email, :password, :phone, :school_district]
    @profile_fields = [:heard_from, :interested_grade_level]
  end
end
