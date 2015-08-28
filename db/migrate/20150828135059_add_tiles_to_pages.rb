class AddTilesToPages < ActiveRecord::Migration
  def change
    add_column :pages, :tiles, :text
  end
end
