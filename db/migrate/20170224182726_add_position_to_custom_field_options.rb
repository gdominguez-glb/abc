class AddPositionToCustomFieldOptions < ActiveRecord::Migration
  def change
    add_column :custom_field_options, :position, :integer, default: 0
  end
end
