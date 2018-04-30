class AddShowed2018NewFeatureTourToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :showed_2018_new_feature_tour, :boolean, default: false
  end
end
