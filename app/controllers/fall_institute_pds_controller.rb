class FallInstitutePdsController < ApplicationController
  def new
    @fall_institute_pd = FallInstitutePd.new
  end

  def create
    @fall_institute_pd = FallInstitutePd.new(fall_institute_pd_params)
    @fall_institute_pd.preferred_contact = (params[:preferred_contact] || []).join(', ')
    @fall_institute_pd.save
  end

  private

  def fall_institute_pd_params
    params.require(:fall_institute_pd).permit(:first_name, :last_name, :role, :email, :phone)
  end
end
