class BlogController < ApplicationController
  before_action :load_curriculum_nav_info, only: [:curriculum, :curriculum_post]
  before_action :load_global_publications, only: [:global, :global_post]
  before_action :load_curriculum_publications, only: [:curriculum, :curriculum_post]

  def global
    load_global_publication
    load_posts
  end

  def global_post
    @post = Post.find(params[:id])
  end

  def curriculum
    load_curriculum_publication
    load_posts
  end

  def curriculum_post
    @post = Post.find(params[:id])
  end

  private
  
  def load_global_publications
    @global_publications = MediumPublication.global
  end

  def load_curriculum_publications
    @curriculum_publications = MediumPublication.curriculum.where(page: @group_page)
  end

  def load_global_publication
    @medium_publication = MediumPublication.global.find_by(slug: params[:slug])
  end

  def load_curriculum_publication
    @medium_publication = MediumPublication.curriculum.find_by(slug: params[:slug])
  end

  def load_posts
    @posts = @medium_publication.posts.order('published_at desc').page(params[:page])
  end

  def load_curriculum_nav_info
    @group_page    = Page.show_in_top_navigation.find_by(slug: params[:page_slug])
    @sub_nav_items = Page.show_in_sub_navigation(@group_page.group_name)
  end
end
