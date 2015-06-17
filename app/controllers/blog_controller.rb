class BlogController < ApplicationController
  before_action :load_global_publications

  def global
    @medium_publication = MediumPublication.global.find_by(slug: params[:slug])
    @posts = @medium_publication.posts.order('published_at desc').page(params[:page])
  end

  def global_post
    @post = Post.find(params[:id])
  end

  private
  
  def load_global_publications
    @global_publications = MediumPublication.global
  end
end
