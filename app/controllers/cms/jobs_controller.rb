class Cms::JobsController < Cms::BaseController
  before_action :find_job, except: [:index, :new, :create, :update_positions]

  def index
    @jobs = Job.order(:position)
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
    if @job.update(job_params)
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

  private

  def job_params
    params.require(:job).permit(:title, :content, :display)
  end

  def find_job
    @job = Job.find(params[:id])
  end
end
