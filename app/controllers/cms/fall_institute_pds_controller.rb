class Cms::FallInstitutePdsController < Cms::BaseController
  def index
    @fall_institute_pds = FallInstitutePd.order(created_at: :desc)

    respond_to do |format|
      format.html {
        @fall_institute_pds = @fall_institute_pds.page(params[:page])
      }
      format.xlsx {}
    end
  end
end
