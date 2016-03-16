class AddSfIsDeletedAndSfVerifiedAndSfCreatedAtToSchoolDistricts < ActiveRecord::Migration
  def change
    add_column :school_districts, :sf_is_deleted, :boolean, default: false
    add_column :school_districts, :sf_verified, :boolean, default: false
    add_column :school_districts, :sf_created_at, :datetime

    add_index :school_districts, :sf_is_deleted
    add_index :school_districts, :sf_verified
    add_index :school_districts, :sf_created_at
  end
end
