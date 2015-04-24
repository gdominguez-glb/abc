class AddGroupRootToPages < ActiveRecord::Migration
  def change
    add_column :pages, :group_root, :boolean, default: false
  end
end
