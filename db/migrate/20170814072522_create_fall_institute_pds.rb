class CreateFallInstitutePds < ActiveRecord::Migration
  def change
    create_table :fall_institute_pds do |t|
      t.string :first_name
      t.string :last_name
      t.string :role
      t.string :email
      t.string :phone
      t.string :preferred_contact

      t.timestamps null: false
    end
  end
end
