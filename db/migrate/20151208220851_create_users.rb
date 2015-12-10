class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.decimal :cash

      t.timestamps null: false
    end
  end
end
