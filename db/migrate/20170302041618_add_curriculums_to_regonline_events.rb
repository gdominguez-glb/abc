class AddCurriculumsToRegonlineEvents < ActiveRecord::Migration
  def change
    add_column :regonline_events, :curriculums, :string
  end
end
