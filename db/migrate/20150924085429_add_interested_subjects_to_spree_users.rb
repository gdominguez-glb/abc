class AddInterestedSubjectsToSpreeUsers < ActiveRecord::Migration
  def up
    add_column :spree_users, :interested_subjects, :text

    remove_column :spree_users, :interested_subject
  end

  def down
    add_column :spree_users, :interested_subject, :string

    remove_column :spree_users, :interested_subjects
  end
end
