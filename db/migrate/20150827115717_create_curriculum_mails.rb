class CreateCurriculumMails < ActiveRecord::Migration
  def change
    create_table :curriculum_mails do |t|
      t.string :curriculum
      t.string :subject
      t.text :content
      t.integer :status

      t.timestamps null: false
    end
  end
end
