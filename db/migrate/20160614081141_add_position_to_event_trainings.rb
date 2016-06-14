class AddPositionToEventTrainings < ActiveRecord::Migration
  def change
    add_column :event_trainings, :position, :integer, default: 0
  end
end
