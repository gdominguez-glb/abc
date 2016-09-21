class AddTrainingTypeCategoryIdToEventTrainings < ActiveRecord::Migration
  def change
    add_column :event_trainings, :training_type_category_id, :integer
  end
end
