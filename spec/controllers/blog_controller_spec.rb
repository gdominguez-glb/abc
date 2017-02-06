require 'rails_helper'

RSpec.describe BlogController, type: :controller do
  include SearchHelper

  let(:global_medium_publication)  { create(:medium_publication, title: 'Eureka Blog', blog_type: 'global', slug: 'global-blog') }
  let(:global_post) { create(:post, medium_publication: global_medium_publication) }

  let(:page) { create(:page, title: 'Math', slug: 'math', group_name: 'Math', visible: true, group_root: true, show_in_nav: true) }
  let(:math_medium_publication)  { create(:medium_publication, title: 'math Blog', blog_type: 'curriculum', slug: 'math-blog', page: page) }
  let(:math_post) { create(:post, medium_publication: math_medium_publication) }

  describe "GET 'global'" do
    it "success" do
      get :global, slug: global_medium_publication.slug

      expect(response).to be_success
      expect(assigns(:blog_type)).to eq('global')
      expect(assigns(:publication_title)).to eq('Eureka Blog')
      expect(assigns(:posts)).not_to be_nil
      expect(assigns(:page_title)).to eq(global_medium_publication.title)
    end
  end

  describe "GET 'global_post'" do
    it "should return success" do
      get :global_post, slug: global_medium_publication.slug, id: global_post.slug

      expect(response).to be_success
      expect(assigns(:post)).to eq(global_post)
    end

    it "should redirect to post with id" do
      get :global_post, slug: global_medium_publication.slug, id: global_post.id
      expect(response).to redirect_to(post_link(global_post))
    end
  end

  describe "GET 'curriculum'" do
    it "success" do
      get :curriculum, page_slug: page.slug, slug: math_medium_publication.slug

      expect(response).to be_success
      expect(assigns(:blog_type)).to eq('curriculum')
      expect(assigns(:posts)).not_to be_nil
    end
  end

  describe "GET 'curriculum_post'" do
    it "success" do
      get :curriculum_post, page_slug: page.slug, slug: math_medium_publication.slug, id: math_post.slug

      expect(response).to be_success
      expect(assigns(:post)).to eq(math_post)
    end

    it "should redirect to post with id" do
      get :global_post, page_slug: page.slug, slug: math_medium_publication.slug, id: math_post.id
      expect(response).to redirect_to(post_link(math_post))
    end
  end
end
