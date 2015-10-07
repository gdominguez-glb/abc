class AddPictureColumnsToStaffs < ActiveRecord::Migration
  def up
    add_attachment :staffs, :picture
  end

  def down
    remove_attachment :staffs, :picture
  end
end
