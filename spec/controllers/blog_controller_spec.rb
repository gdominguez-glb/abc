require 'rails_helper'

RSpec.describe BlogController, type: :controller do
  include SearchHelper

  let(:global_blog) { create(:blog, title: 'Eureka Blog', blog_type: :global, slug: 'eureka', display: true) }
  let(:global_post) { create(:article, blog: global_blog, slug: 'aaa', display: true, publish_status: :published) }

  let(:page) { create(:page, title: 'Math', slug: 'math', group_name: 'Math', visible: true, group_root: true, show_in_nav: true) }
  let(:curriculum_blog) { create(:blog, title: 'English Blog', blog_type: :curriculum, slug: 'english', display: true, page: page) }
  let(:curriculum_post) { create(:article, blog: curriculum_blog, slug: 'bbb', display: true, publish_status: :published) }

  describe "GET 'global'" do
    it "success" do
      get :global, slug: global_blog.slug

      expect(response).to be_success
      expect(assigns(:blog_type)).to eq('global')
      expect(assigns(:articles)).not_to be_nil
      expect(assigns(:blog_title)).to eq(global_blog.title)
    end
  end

  describe "GET 'global_post'" do
    it "should return success" do
      get :global_post, slug: global_blog.slug, id: global_post.slug

      expect(response).to be_success
      expect(assigns(:article)).to eq(global_post)
    end
  end

  describe "GET 'curriculum'" do
    it "success" do
      get :curriculum, page_slug: page.slug, slug: curriculum_blog.slug

      expect(response).to be_success
      expect(assigns(:blog_type)).to eq('curriculum')
      expect(assigns(:articles)).not_to be_nil
    end
  end

  describe "GET 'curriculum_post'" do
    it "success" do
      get :curriculum_post, page_slug: page.slug, slug: curriculum_blog.slug, id: curriculum_post.slug

      expect(response).to be_success
      expect(assigns(:article)).to eq(curriculum_post)
    end
  end
end
