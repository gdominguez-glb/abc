class Cms::BlogsController < Cms::BaseController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  def index
    @blogs = Blog.all
  end

  def new
    @blog = Blog.new(blog_type: :global)
  end

  def create
    @blog = Blog.new(blog_params)
    if @blog.save
      redirect_to cms_blogs_path, notice: 'Successfully create new blog.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @blog.update(blog_params)
      redirect_to cms_blogs_path, notice: 'Successfully updated blog.'
    else
      render :edit
    end
  end

  def destroy
    @blog.destroy
    redirect_to cms_blogs_path, notice: 'Successfully deleted blog.'
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :blog_type, :page_id, :position, :display, :slug, :header, :description)
  end
end
