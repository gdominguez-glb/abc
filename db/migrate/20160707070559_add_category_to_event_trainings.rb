class AddCategoryToEventTrainings < ActiveRecord::Migration
  def change
    add_column :event_trainings, :category, :string
  end
end
