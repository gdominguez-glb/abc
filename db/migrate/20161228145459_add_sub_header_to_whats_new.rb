class AddSubHeaderToWhatsNew < ActiveRecord::Migration
  def change
    add_column :whats_news, :sub_header, :text, after: :title
  end
end
