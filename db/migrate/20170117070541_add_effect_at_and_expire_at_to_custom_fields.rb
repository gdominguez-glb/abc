class AddEffectAtAndExpireAtToCustomFields < ActiveRecord::Migration
  def change
    add_column :custom_fields, :effect_at, :datetime
    add_column :custom_fields, :expire_at, :datetime
  end
end
