class AddCurriculumIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :curriculum_id, :integer
  end
end
