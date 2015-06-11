class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.string :title
      t.text :sub_header
      t.string :call_to_action_button_text
      t.string :call_to_action_button_link

      t.timestamps null: false
    end
  end
end
