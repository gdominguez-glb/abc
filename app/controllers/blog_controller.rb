class BlogController < ApplicationController
  before_action :authenticate_user!, only: [:subscribe]
  before_action :load_curriculum_nav_info, only: [:curriculum, :curriculum_post]
  before_action :load_global_publications, only: [:global, :global_post]
  before_action :load_curriculum_publications, only: [:curriculum, :curriculum_post]

  # new blog before_actions
  before_action :load_global_blogs, only: [:global, :global_post]
  before_action :load_curriculum_blogs, only: [:curriculum, :curriculum_post]

  include SearchHelper

  def global
    @blog_type = 'global'

    load_global_blog
    load_articles
    @blog_title = @blog.title
  end

  def global_post
    @blog_type = 'global'

    load_global_blog
    find_article
  end

  def curriculum
    @blog_type = 'curriculum'

    load_curriculum_blog
    load_articles
    @blog_title = @blog.title
  end

  def curriculum_post
    @blog_type = 'curriculum'

    load_curriculum_blog
    find_article
  end

  def subscribe
    @blog = Blog.find(params[:id])
    current_spree_user.subscribe!(@blog)
    redirect_back(fallback_location: '/', notice: t(
      'controllers.blog.subscribe',
      title: @blog.title
    ))
  end

  def unsubscribe
    @blog = Blog.find(params[:id])
    current_spree_user.unsubscribe!(@blog)
    redirect_back(fallback_location: '/', notice: t(
      'controllers.blog.unsubscribe',
      title: @blog.title
    ))
  end

  private

  def load_global_publications
    @global_publications = MediumPublication.global.displayable
  end

  def load_curriculum_publications
    @curriculum_publications = MediumPublication.curriculum.displayable.where(page: @group_page).sorted
  end

  # TODO: Unused method we need to remove it
  def load_global_publication
    @medium_publication = MediumPublication.global.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound.new('blog not exist') if @medium_publication.blank?
    @page_title = @medium_publication.title
  end

  # TODO: Unused method we need to remove it
  def load_curriculum_publication
    @medium_publication = MediumPublication.curriculum.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound.new('blog not exist') if @medium_publication.blank?
    @page_title = @medium_publication.title
  end

  def load_posts
    @posts = @medium_publication.posts.order('published_at desc').page(params[:page])
  end

  def load_curriculum_nav_info
    @group_page    = (
      Page.show_in_top_navigation.find_by(slug: params[:page_slug]) || Page.show_in_top_navigation.find_by(slug: params[:page_slug].downcase)
    )
    @sub_nav_items = Page.show_in_sub_navigation(@group_page.group_name)
  end

  def find_post
    post_with_id = Post.find_by(id: params[:id])
    if post_with_id.present?
      redirect_to post_link(post_with_id) and return
    end
    @post = Post.find_by(slug: params[:id])
    raise ActiveRecord::RecordNotFound.new('post not exist') if @post.blank?
  end

  # new blog codes

  def load_global_blogs
    @blogs = Blog.global.displayable
  end

  def load_global_blog
    @blog = Blog.global.displayable.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound.new('blog not exist') if @blog.blank?
  end

  def load_curriculum_blog
    @blog = Blog.curriculum.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound.new('blog not exist') if @blog.blank?
    @page_title = @blog.title
  end

  def load_curriculum_blogs
    @curriculum_blogs = Blog.curriculum.displayable.where(page: @group_page).sorted
  end

  def load_articles
    @articles = @blog.articles.displayable.published.sorted.search_by_text(params[:q]).page(params[:page]).per(9)
  end

  def find_article
    @article = @blog.articles.displayable.published.find_by(slug: params[:id])
    raise ActiveRecord::RecordNotFound.new('post not exist') if @article.blank?
  end
end
