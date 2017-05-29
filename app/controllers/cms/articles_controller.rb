class Cms::ArticlesController < Cms::BaseController
  before_action :set_blog
  before_action :find_article, only: [:edit, :update, :destroy, :publish, :archive, :unarchive]

  def index
    redirect_to published_cms_blog_articles_path
  end

  def published
    @articles = @blog.articles.published.unarchive.sorted.page(params[:page])
  end

  def drafts
    @articles = @blog.articles.draft.unarchive.sorted.page(params[:page])
  end

  def archived
    @articles = @blog.articles.archived.sorted.page(params[:page])
  end

  def new
    @article = @blog.articles.build
  end

  def create
    @article = @blog.articles.build(article_params.merge(user: current_spree_user))
    if @article.save
      redirect_to edit_cms_blog_article_path(@blog, @article), notice: 'Post created successfully'
    else
      render :new
    end
  end

  def edit
  end

  def update
    draft_status = @article.published? ? :draft_in_progress : :draft
    if @article.update(article_params.merge(draft_status: draft_status))
      redirect_to edit_cms_blog_article_path(@blog, @article), notice: 'Update post successfully'
    else
      render :edit
    end
  end

  def preview
    @article = @blog.articles.find(params[:id])
    render layout: 'application'
  end

  def destroy
    @article.destroy
    redirect_to cms_blog_articles_path(@blog), notice: 'Destroy post successfully'
  end

  def publish
    @article.publish!
    @article.send_subscription_notifications
    redirect_to cms_blog_articles_path(@blog), notice: 'Blog post published successfully'
  end

  def archive
    @article.archive!
    redirect_to archived_cms_blog_articles_path(@blog), notice: 'Blog post archived successfully'
  end

  def unarchive
    @article.unarchive!
    redirect_to cms_blog_articles_path(@blog), notice: 'Blog post un-archived successfully'
  end

  private

  def set_blog
    @blog = Blog.find(params[:blog_id])
  end

  def find_article
    @article = @blog.articles.find(params[:id])
  end

  def article_params
    params.require(:article).permit!
  end
end
