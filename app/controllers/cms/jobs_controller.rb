class Cms::JobsController < Cms::BaseController
  skip_before_action :authenticate_admin_in_cms!
  before_action :authenticate_hr_admin_in_cms!

  before_action :find_job, except: [:index, :new, :create, :update_positions, :published, :drafts, :archived]

  def index
    redirect_to published_cms_jobs_path
  end

  def published
    @jobs = Job.published.unarchive.order(:position)
  end

  def drafts
    @jobs = Job.draft.unarchive.order(:position)
  end

  def archived
    @jobs = Job.archived.order(:position)
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to cms_jobs_path, notice: 'Created job successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    draft_status = @job.published? ? :draft_in_progress : :draft
    if @job.update(job_params.merge(draft_status: draft_status))
      redirect_to cms_jobs_path, notice: 'Updated job successfully!'
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    redirect_to cms_jobs_path, notice: 'Deleted job successfully!'
  end

  def update_positions
    update_positions_with_klass(Job)
    render nothing: true
  end

  def publish
    @job.publish!
    redirect_to edit_cms_job_path(@job), notice: 'Publish career successfully!'
  end

  def preview
    render layout: 'application'
  end

  def archive
    @job.archive!
    redirect_to archived_cms_jobs_path, notice: 'Archived career successfully!'
  end

  private

  def job_params
    params.require(:job).permit(:title, :content, :display)
  end

  def find_job
    @job = Job.find(params[:id])
  end
end
