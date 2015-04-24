class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :seo_content
      t.string :slug, null: false
      t.string :group_name
      t.string :sub_group_name
      t.integer :position, default: 0
      t.string :layout
      t.text :body
      t.boolean :visible, default: false

      t.timestamps null: false
    end
  end
end
