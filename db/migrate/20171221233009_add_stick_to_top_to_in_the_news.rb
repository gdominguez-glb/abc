class AddStickToTopToInTheNews < ActiveRecord::Migration
  def change
    add_column :in_the_news, :stick_to_top, :boolean, default: false
  end
end
