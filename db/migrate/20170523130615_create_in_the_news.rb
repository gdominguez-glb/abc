class CreateInTheNews < ActiveRecord::Migration
  def change
    create_table :in_the_news do |t|
      t.string :call_to_action_button_link
      t.string :call_to_action_button_target
      t.string :call_to_action_button_text
      t.string :title
      t.string :author
      t.string :publisher
      t.string :slug
      t.string :image_url
      t.datetime :article_date
      t.string :description

      t.timestamps null: false
    end
  end
end
