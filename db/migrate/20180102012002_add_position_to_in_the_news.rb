class AddPositionToInTheNews < ActiveRecord::Migration
  def change
    add_column :in_the_news, :position, :integer, default: 0
  end
end
