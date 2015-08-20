class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :content
      t.boolean :display

      t.timestamps null: false
    end
  end
end
