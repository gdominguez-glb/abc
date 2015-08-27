class Cms::CurriculumMailsController < Cms::BaseController
  before_action :set_curriculum_mail, only: [:show, :edit, :update, :destroy]

  def index
    @curriculum_mails = CurriculumMail.page(params[:page])
  end

  def show
  end

  def new
    @curriculum_mail = CurriculumMail.new
  end

  def edit
  end

  def create
    @curriculum_mail = CurriculumMail.new(curriculum_mail_params)

    if @curriculum_mail.save
      redirect_to cms_curriculum_mails_path, notice: 'CurriculumMail was successfully created.'
    else
      render :new
    end
  end

  def update
    if @curriculum_mail.update(curriculum_mail_params)
      redirect_to cms_curriculum_mails_path, notice: 'CurriculumMail was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @curriculum_mail.destroy
    redirect_to cms_curriculum_mails_url, notice: 'CurriculumMail was successfully destroyed.'
  end

  private

  def set_curriculum_mail
    @curriculum_mail = CurriculumMail.find(params[:id])
  end

  def curriculum_mail_params
    params.require(:curriculum_mail).permit(:subject, :content, :curriculum)
  end
end
