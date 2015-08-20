class CreateHelpItems < ActiveRecord::Migration
  def change
    create_table :help_items do |t|
      t.string :title
      t.text :content
      t.boolean :display, default: false
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
