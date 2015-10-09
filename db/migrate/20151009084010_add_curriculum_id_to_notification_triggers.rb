class AddCurriculumIdToNotificationTriggers < ActiveRecord::Migration
  def change
    add_column :notification_triggers, :curriculum_id, :integer
  end
end
