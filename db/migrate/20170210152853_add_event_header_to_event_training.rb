class AddEventHeaderToEventTraining < ActiveRecord::Migration
  def change
    add_reference :event_trainings, :event_training_header
  end
end
