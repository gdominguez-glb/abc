class AddCurriculumTypeToNotificationTriggers < ActiveRecord::Migration
  def change
    add_column :notification_triggers, :curriculum_type, :string
  end
end
