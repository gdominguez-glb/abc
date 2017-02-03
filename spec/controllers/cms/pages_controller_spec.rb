require 'rails_helper'

RSpec.describe Cms::PagesController, type: :controller do
  let(:page) { create(:page) }

  login_admin

  describe "GET 'index'" do
    it "redirect to published" do
      get :index
      expect(response).to redirect_to('/cms/pages/published')
    end
  end

  describe "GET 'search'" do
    it "search pages" do
      get :search, q: { title_or_slug_or_curriculum_name_cont: 'a' }
      expect(response).to be_success
      expect(assigns(:pages)).not_to be_nil
    end
  end

  describe "GET 'pubished'" do
    it "success" do
      get :published
      expect(response).to be_success
    end
  end

  describe "GET 'published_category'" do
    it "success" do
      page = create(:page, publish_status: :published, show_in_footer: true)
      get :published_category, category: 'Footer'
      expect(response).to be_success
      expect(assigns(:pages)).to eq([page])
    end
  end

  describe "GET 'drafts'" do
    it "success" do
      get :drafts
      expect(response).to be_success
    end
  end

  describe "GET 'drafts_category'" do
    it "success" do
      page = create(:page, draft_status: :draft, show_in_footer: true)
      get :drafts_category, category: 'Footer'
      expect(response).to be_success
      expect(assigns(:pages)).to eq([page])
    end
  end

  describe "GET 'archived'" do
    it "success" do
      get :archived
      expect(response).to be_success
    end
  end

  describe "GET 'archived_category'" do
    it "success" do
      page = create(:page, archived: true, show_in_footer: true)
      get :archived_category, category: 'Footer'
      expect(response).to be_success
      expect(assigns(:pages)).to eq([page])
    end
  end

  describe "GET 'show'" do

    it "success" do
      get :show, id: page.id
      expect(response).to be_success
      expect(assigns(:page)).not_to be_nil
    end
  end

  describe "GET 'new'" do
    it "success" do
      get :new
      expect(response).to be_success
      expect(assigns(:page)).not_to be_nil
    end
  end

  describe "POST 'create'" do
    it "success" do
      post :create, page: { title: 'a', slug: 'b', group_name: 'c' }
      expect(response).to be_redirect
    end

    it "fail" do
      post :create, page: { title: '' }
      expect(response).to render_template(:new)
    end
  end

  describe "GET 'edit'" do
    it "success" do
      get :edit, id: page.id
      expect(response).to be_success
      expect(assigns(:page)).not_to be_nil
    end
  end

  describe "PUT 'update'" do
    it "update successfully" do
      put :update, id: page.id, page: { title: 'new title' }
      expect(response).to be_redirect
    end

    it "fail to update" do
      put :update, id: page.id, page: { title: '' }
      expect(response).to render_template(:edit)
    end
  end

  describe "DELETE 'destroy'" do
    it "destroy successfully" do
      delete :destroy, id: page.id
      expect(response).to be_redirect
      expect(Page.find_by(id: page.id)).to be_nil
    end
  end

  describe "POST 'publish'" do
    it "publish page" do
      post :publish, id: page.id
      expect(response).to redirect_to(edit_cms_page_path(page))
      expect(page.reload.published?).to eq(true)
    end
  end

  describe "POST 'archive'" do
    it 'archive page' do
      post :archive, id: page.id
      expect(response).to redirect_to(archived_cms_pages_path)
      expect(page.reload.archived?).to eq(true)
      expect(page.reload.archived_at).not_to be_nil
    end
  end

  describe "POST 'unarchive'" do
    it 'unarchive page' do
      post :unarchive, id: page.id
      expect(response).to redirect_to(published_cms_pages_path)
      expect(page.reload.archived?).to eq(false)
      expect(page.reload.archived_at).to be_nil
    end
  end

  describe "GET 'preview'" do
    it "preview page" do
      get :preview, id: page.id
      expect(response).to render_template('preview', 'application')
    end
  end

  describe "POST 'copy_page'" do
    context '#copy_page' do
      it 'should redirect to the new page' do
        post :copy_page, id: page.id
        expect(response).to redirect_to(edit_cms_page_path(Page.order(created_at: :desc).first))
      end
    end
  end
end
