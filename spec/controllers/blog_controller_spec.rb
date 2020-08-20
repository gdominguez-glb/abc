require 'rails_helper'

RSpec.describe BlogController, type: :controller do
  include SearchHelper

  let!(:user) { create(:gm_user) }

  let(:global_blog) do
    create(
      :blog,
      title: 'Eureka Blog',
      blog_type: :global,
      slug: 'eureka',
      display: true
    )
  end
  let(:global_post) do
    create(
      :article,
      blog: global_blog,
      slug: 'aaa',
      display: true,
      publish_status: :published
    )
  end

  let(:page) do
    create(
      :page,
      title: 'Math',
      slug: 'math',
      group_name: 'Math',
      visible: true,
      group_root: true,
      show_in_nav: true
    )
  end
  let(:curriculum_blog) do
    create(
      :blog,
      title: 'English Blog',
      blog_type: :curriculum,
      slug: 'english',
      display: true,
      page: page
    )
  end
  let(:curriculum_post) do
    create(
      :article,
      blog: curriculum_blog,
      slug: 'bbb',
      display: true,
      publish_status: :published
    )
  end

  before(:each) do
    allow(controller).to receive(:current_spree_user) { user }
  end


  describe "GET 'global'" do
    it "success" do
      get :global, params: { slug: global_blog.slug }

      expect(response).to be_success
      expect(assigns(:blog_type)).to eq('global')
      expect(assigns(:articles)).not_to be_nil
      expect(assigns(:blog_title)).to eq(global_blog.title)
    end
  end

  describe "GET 'global_post'" do
    it "should return success" do
      get :global_post, params: { slug: global_blog.slug,
                                  id: global_post.slug }

      expect(response).to be_success
      expect(assigns(:article)).to eq(global_post)
    end
  end

  describe "GET 'curriculum'" do
    it "success" do
      get :curriculum, params: { page_slug: page.slug,
                                 slug: curriculum_blog.slug }

      expect(response).to be_success
      expect(assigns(:blog_type)).to eq('curriculum')
      expect(assigns(:articles)).not_to be_nil
    end
  end

  describe "GET 'curriculum_post'" do
    it "success" do
      get :curriculum_post, params: { page_slug: page.slug,
                                      slug: curriculum_blog.slug,
                                      id: curriculum_post.slug }

      expect(response).to be_success
      expect(assigns(:article)).to eq(curriculum_post)
    end
  end

  describe "POST 'subscribe'" do
    login_user

    it 'should subscribe the blog' do
      @request.env['HTTP_REFERER'] = '/cms/event_pages/published'
      post :subscribe,
           params: { id: curriculum_blog.id }

      notice_msg =
        "Thank you for subscribing to #{curriculum_blog.title}. "\
        'Whenever a new blog post is published you will '\
        'receive an email notifying you. If you wish to '\
        'unsubscribe, go to your settings and click '\
        'Unsuscribe in the Blog Subscription section.'
      expect(flash[:notice]).to eq(notice_msg)
    end
  end

  describe "POST 'unsubscribe'" do
    it 'should unsubscribe the blog' do
      @request.env['HTTP_REFERER'] = '/cms/event_pages/published'
      post :unsubscribe,
           params: { id: curriculum_blog.id }

      notice_msg =
        "Successfully unsubscribe #{curriculum_blog.title}"
      expect(flash[:notice]).to eq(notice_msg)
    end
  end
end
