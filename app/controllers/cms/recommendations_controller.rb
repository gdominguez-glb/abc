class Cms::RecommendationsController < Cms::BaseController
  include WhatsnewRecommendationSharable

  before_action :find_recommendation, except: [:index, :new, :create, :search]
  before_action -> { sanatize_role_params(:recommendation) }, only: [:create, :update]

  def index
    @recommendation = Recommendation.new
    @recommendations = Recommendation.page(params[:page]).per(params[:per_page])
  end

  def new
    @recommendation = Recommendation.new
  end

  def create
    @recommendation = Recommendation.new(recommendation_params)
    if @recommendation.save
      redirect_to cms_recommendations_path, notice: 'Created recommendation successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @recommendation.update(recommendation_params)
      redirect_to cms_recommendations_path, notice: 'Updated recommendation successfully!'
    else
      render :edit
    end
  end

  def destroy
    @recommendation.destroy
    redirect_to cms_recommendations_path, notice: 'Delete successfully'
  end

  def preview
    @recommendations = Recommendation.where(id: params[:id])
  end

  def search
    @recommendation = Recommendation.new({
      title: params[:recommendation][:title],
      subject: params[:recommendation][:subject],
      user_title: params[:recommendation][:user_title]
    })

    @recommendations = Recommendation
                        .search_by_title(params[:recommendation][:title])
                        .with_subject(params[:recommendation][:subject])
                        .search_by_user_title(params[:recommendation][:user_title])

    @recommendations = @recommendations.page(params[:page]).per(params[:per_page])
    render :index
  end

  private

  def recommendation_params
    _params = [
      :title,
      :sub_header,
      :subject,
      :display,
      :call_to_action_button_text,
      :call_to_action_button_link,
      :call_to_action_button_target,
      :expire_at,
      :icon,
      :image_url,
      :product_ids,
      :user_title,
      :position,
      :zip_codes,
      :image_contain
    ]

    require_params(:recommendation, _params, :product_ids)
  end

  def find_recommendation
    @recommendation = Recommendation.find(params[:id])
  end
end
