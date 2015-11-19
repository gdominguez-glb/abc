module SchoolDistrictParamProcessor
  extend ActiveSupport::Concern

  def process_school_district_param(user_params)
    process_school_district_id(user_params)
    if %w(Parent Homeschooler).member?(user_params[:title])
      process_unaffiliated_school_district(user_params)
    elsif user_params[:school_district_id].blank?
      user_params.delete(:school_district_id)
    elsif (user_params[:school_district_id].present? || user_params[:school_district_attributes][:name].blank?)
      user_params.delete(:school_district_attributes)
    end
  end

  def process_school_district_id(user_params)
    user_params[:school_district_id] = user_params[:school_id].blank? ? user_params[:district_id] : user_params[:school_id]
    if user_params[:school_district_id].include?('Not Listed')
      user_params.delete(:school_district_id)
    end
  end

  def process_unaffiliated_school_district(user_params)
    user_params.delete(:school_district_id)
    name = "#{user_params[:first_name]} #{user_params[:last_name]}".strip
    user_params[:school_district_attributes][:name] = name
    user_params[:school_district_attributes][:place_type] = 'unaffiliated'
  end
end
