class Cms::SubscribersController < Cms::BaseController
  before_action :find_blog

  def index
    @q = @blog.users.search(params[:q])
    @users = @q.result.page(params[:page])
  end

  def export
    @users = @blog.users.search(params[:q]).result
    respond_to do |format|
      format.xlsx {}
    end
  end

  private

  def find_blog
    @blog = Blog.find(params[:blog_id])
  end
end
