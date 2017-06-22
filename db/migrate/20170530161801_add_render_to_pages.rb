class AddRenderToPages < ActiveRecord::Migration
  def change
    add_column :pages, :render, :string, default: ""
    add_column :pages, :data, :text, default: nil
  end
end
