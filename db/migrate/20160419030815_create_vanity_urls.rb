class CreateVanityUrls < ActiveRecord::Migration
  def change
    create_table :vanity_urls do |t|
      t.string :url
      t.string :redirect_url

      t.timestamps null: false
    end
  end
end
