class Cms::HelpItemsController < Cms::BaseController
  before_action :find_help_item, except: [:index, :new, :create]

  def index
    @help_items = HelpItem.page(params[:page])
  end

  def new
    @help_item = HelpItem.new
  end

  def create
    @help_item = HelpItem.new(help_item_params)
    if @help_item.save
      redirect_to cms_help_items_path, notice: 'Created help item successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @help_item.update(help_item_params)
      redirect_to cms_help_items_path, notice: 'Updated help item successfully!'
    else
      render :edit
    end
  end

  def destroy
    @help_item.destroy
    redirect_to cms_help_items_path, notice: 'Deleted help item successfully!'
  end


  private

  def find_help_item
    @help_item = HelpItem.find(params[:id])
  end

  def help_item_params
    params.require(:help_item).permit(:title, :content, :display)
  end
end
