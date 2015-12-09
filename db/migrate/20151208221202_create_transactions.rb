class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :stock
      t.decimal :buy
      t.integer :quantity
      t.decimal :sell
      t.boolean :open

      t.timestamps null: false
    end
  end
end
