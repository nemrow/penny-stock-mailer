class AddNameToStock < ActiveRecord::Migration
  def change
    add_column :stocks, :name, :string
  end
end
