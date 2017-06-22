class CreatePopups < ActiveRecord::Migration
  def change
    create_table :popups do |t|
      t.string :title
      t.text :body
      t.string :slug
      t.string :button_link
      t.string :button_text
      t.string :text_color
      t.string :background_color
      t.datetime :starts_at
      t.datetime :expires_at

      t.timestamps null: false
    end
  end
end
