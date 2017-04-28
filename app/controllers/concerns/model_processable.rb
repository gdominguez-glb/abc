module ModelProcessable
  extend ActiveSupport::Concerns

  def process_create(model, redirect)
    if model.save
      redirect_to redirect, notice: 'Created successfully'
    else
      render :new
    end
  end

  def process_update(model, redirect, params)
    if model.update(params)
      redirect_to redirect, notice: 'Updated successfully'
    else
      render :edit
    end
  end
end