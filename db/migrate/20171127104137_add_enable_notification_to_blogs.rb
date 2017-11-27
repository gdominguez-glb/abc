class AddEnableNotificationToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :enable_notification, :boolean, default: true
  end
end
