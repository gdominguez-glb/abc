class AddShowInFooterToPages < ActiveRecord::Migration
  def change
    add_column :pages, :show_in_footer, :boolean, default: false
  end
end
