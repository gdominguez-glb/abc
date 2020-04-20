# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VideoGalleryController, type: :controller do
  describe 'GET index' do
    it 'Should list the videos' do
      user = create :gm_user
      create :spree_video, is_free: true

      sign_in :spree_user, user

      get :index

      expect(assigns(:videos)).not_to be_empty
    end

    it 'Should list the videos locked' do
      user = create :gm_user
      create :spree_video

      sign_in :spree_user, user

      get :index

      expect(assigns(:videos)).not_to be_empty
      expect(assigns(:videos).first.is_free?).to be_falsy
    end

    it 'Should filter the videos' do
      user = create :gm_user
      create :spree_video, title: 'name'
      create :spree_video, title: 'lorem ipsumi dolor'

      sign_in :spree_user, user

      get :index, query: 'name'

      expect(assigns(:videos)).not_to be_empty
      expect(assigns(:videos).count).to eq(1)
      expect(assigns(:videos).first.title).to eq('name')
    end
  end

  describe 'GET play' do
    it 'Should load the video modal' do
      user = create :gm_user
      video = create :spree_video, title: 'name'

      sign_in :spree_user, user

      xhr :get, :play, id: video.id, format: :js

      expect(subject).to render_template('video_gallery/play')
    end
  end

  describe 'GET unlock' do
    it 'Should redirect to product path' do
      user = create :gm_user
      video_group = create(:spree_video_group, name: 'Teach Eureka')
      create(:product, video_group: video_group)
      video = create :spree_video, title: 'name', video_group_id: video_group.id

      sign_in :spree_user, user

      get :unlock, id: video.id

      expect(response.headers['Location']).to include('products/product-1')
    end

    it 'Should load notice for product no available' do
      user = create :gm_user
      video = create :spree_video, title: 'name'

      sign_in :spree_user, user

      get :unlock, id: video.id

      notice = 'Not available for purchase!'

      expect(subject).to redirect_to('/video_gallery')
      expect(subject.request.flash[:notice]).to eq(notice)
    end

    it 'Should load notice for product in beta' do
      user = create :gm_user
      video_group = create(:spree_video_group, name: 'Teach Eureka')
      create(:product, video_group: video_group, is_beta: true)
      video = create :spree_video, title: 'name', video_group_id: video_group.id

      sign_in :spree_user, user

      get :unlock, id: video.id

      notice = 'This product is currently in beta!'

      expect(subject).to redirect_to('/video_gallery')
      expect(subject.request.flash[:notice]).to eq(notice)
    end

    it 'Should load js template' do
      user = create :gm_user
      video = create :spree_video, title: 'name'

      sign_in :spree_user, user

      xhr :get, :unlock, id: video.id, format: :js

      expect(subject).to render_template('video_gallery/unlock')
    end
  end
end
