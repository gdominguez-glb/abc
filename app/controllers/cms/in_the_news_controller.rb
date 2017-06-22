class Cms::InTheNewsController < Cms::BaseController
  before_action :find_in_the_news, only: [:edit, :update, :destroy]
  before_action :find_page,  only: [:edit_page, :save_page]

  def index
    @in_the_new = InTheNew.new
    @in_the_news = InTheNew.page(params[:page]).per(params[:per_page])
  end

  def new
    @in_the_new = InTheNew.new
  end

  def create
    @in_the_new = InTheNew.new(in_the_new_params)
    if @in_the_new.save
      redirect_to cms_in_the_news_path, notice: 'Created successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @in_the_new.update(in_the_new_params)
      redirect_to cms_in_the_news_path, notice: 'Updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    @in_the_new.destroy
    redirect_to cms_in_the_news_path, notice: 'Delete successfully'
  end

  def search
    @in_the_new = InTheNew.new({
      title: params[:in_the_new][:title],
      author: params[:in_the_new][:author],
      publisher: params[:in_the_new][:publisher],
      article_date: params[:in_the_new][:article_date],
      description: params[:in_the_new][:description],
    })

    @in_the_news = InTheNew
                       .search_by_title(params[:in_the_new][:title])
                       .search_by_author(params[:in_the_new][:author])
                       .search_by_publisher(params[:in_the_new][:publisher])
                       .search_by_article_date(params[:in_the_new][:article_date])
                       .search_by_description(params[:in_the_new][:description])

    @in_the_news = @in_the_news.page(params[:page]).per(params[:per_page])

    render :index
  end

  def edit_page
  end

  def save_page
    if @page.update(page_params)
      redirect_to cms_in_the_news_path, notice: 'Updated successfully!'
    else
      render :edit_page
    end
  end

  private

  def find_in_the_news
    @in_the_new = InTheNew.find(params[:id])
  end

  def find_page
    @page = Page.find_by(render: 'in_the_news')
  end

  def in_the_new_params
    params.require(:in_the_new).permit(
      :article_date, :author,
      :call_to_action_button_link,
      :call_to_action_button_target,
      :call_to_action_button_text,
      :description,
      :image_url,
      :publisher,
      :slug,
      :title
    )
  end

  def page_params
    params.require(:page).permit({:data => [:jumbotron_image, :short_description]}, :title, :slug)
  end
end
