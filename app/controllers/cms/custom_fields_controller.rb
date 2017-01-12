class Cms::CustomFieldsController < Cms::BaseController
  before_action :find_custom_field, only: [:edit, :update, :destroy]

  def index
    @custom_fields = CustomField.order(:position)
  end

  def new
    @custom_field = CustomField.new
  end

  def create
    @custom_field = CustomField.new(custom_field_params)
    if @custom_field.save
      redirect_to cms_custom_fields_path, notice: 'Created custom field successfully'
    else
      flash.now[:error] = "Fail to create custom field"
      render :new
    end
  end

  def edit
  end

  def update
    if @custom_field.update(custom_field_params)
      redirect_to cms_custom_fields_path, notice: 'Updated custom field successfully'
    else
      flash.now[:error] = "Fail to update custom field"
      render :new
    end
  end

  def destroy
    @custom_field.destroy
    redirect_to cms_custom_fields_path, notice: 'Deleted custom field successfully'
  end

  def update_positions
    update_positions_with_klass(CustomField)
    render nothing: true
  end

  private

  def custom_field_params
    params.require(:custom_field).permit!
  end

  def find_custom_field
    @custom_field = CustomField.find(params[:id])
  end
end
