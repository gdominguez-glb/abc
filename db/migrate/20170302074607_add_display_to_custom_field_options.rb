class AddDisplayToCustomFieldOptions < ActiveRecord::Migration
  def change
    add_column :custom_field_options, :display, :boolean, default: true
  end
end
