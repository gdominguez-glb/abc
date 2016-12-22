class CreateWhatsnews < ActiveRecord::Migration
  def change
    create_table :whats_news do |t|
      t.string :title
      t.string :url
      t.string :call_to_action_button_text
      t.string :call_to_action_button_link
      t.string :call_to_action_button_target
      t.boolean :display
      t.string :user_title
      t.string :subject
      t.string :icon, null: true
      t.integer :views, default: 0
      t.integer :clicks, default: 0
      t.text :zip_codes

      t.timestamps null: false
    end
  end
end
