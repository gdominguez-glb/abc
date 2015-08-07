class HomeController < ApplicationController
  def index
    @curriculums = Page.curriculum_nav.map(&:curriculum)
  end

  def decide_page_to_go
    @curriculum = Curriculum.find(params[:curriculum_id])
    @role       = params[:role]

    page_url = case @role
               when *['Teacher', 'Homeschooler']
                 @curriculum.teacher_page
               when 'Administrative Assistant'
                 @curriculum.shop_page
               when 'Parent'
                 @curriculum.parent_page
               when 'Administrator'
                 @curriculum.admin_page
               end
    redirect_to "/#{page_url}"
  end
end
