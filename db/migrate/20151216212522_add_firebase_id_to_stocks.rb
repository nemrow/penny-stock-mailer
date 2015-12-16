class AddFirebaseIdToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :firebase_id, :string
  end
end
