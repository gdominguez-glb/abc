class AddSfIsDeletedAndSfVerifiedAndSfCreatedAtToSchoolDistricts < ActiveRecord::Migration
  def change
    add_column :school_districts, :sf_is_deleted, :boolean, default: false
    add_column :school_districts, :sf_verified, :boolean, default: false
    add_column :school_districts, :sf_created_at, :datetime
  end
end
