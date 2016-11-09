class BlogController < ApplicationController
  before_action :load_curriculum_nav_info, only: [:curriculum, :curriculum_post]
  before_action :load_global_publications, only: [:global, :global_post]
  before_action :load_curriculum_publications, only: [:curriculum, :curriculum_post]

  def global
    @blog_type = 'global'
    load_global_publication
    load_posts
    @publication_title = @medium_publication.title
  end

  def global_post
    find_post
  end

  def curriculum
    @blog_type = 'curriculum'

    load_curriculum_publication
    load_posts
  end

  def curriculum_post
    find_post
  end

  private

  def load_global_publications
    @global_publications = MediumPublication.global
  end

  def load_curriculum_publications
    @curriculum_publications = MediumPublication.curriculum.where(page: @group_page).sorted
  end

  def load_global_publication
    @medium_publication = MediumPublication.global.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound.new('blog not exist') if @medium_publication.blank?
    @page_title = @medium_publication.title
  end

  def load_curriculum_publication
    @medium_publication = MediumPublication.curriculum.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound.new('blog not exist') if @medium_publication.blank?
    @page_title = @medium_publication.title
  end

  def load_posts
    @posts = @medium_publication.posts.order('published_at desc').page(params[:page])
  end

  def load_curriculum_nav_info
    @group_page    = Page.show_in_top_navigation.find_by(slug: params[:page_slug])
    @sub_nav_items = Page.show_in_sub_navigation(@group_page.group_name)
  end

  include SearchHelper
  def find_post
    post_with_id = Post.find_by(id: params[:id])
    if post_with_id.present?
      redirect_to post_link(post_with_id) and return
    end
    @post = Post.find_by(slug: params[:id])
    raise ActiveRecord::RecordNotFound.new('post not exist') if @post.blank?
  end
end
