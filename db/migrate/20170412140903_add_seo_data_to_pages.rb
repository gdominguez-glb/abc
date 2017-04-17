class AddSeoDataToPages < ActiveRecord::Migration
  def change
    add_column :pages, :seo_data, :text
  end
end
