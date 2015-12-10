class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :stock
      t.decimal :buy
      t.decimal :total_buy_price
      t.decimal :sell
      t.decimal :total_sell_price
      t.integer :quantity
      t.boolean :open
      t.decimal :profit_loss_per_share
      t.decimal :total_profit_loss

      t.timestamps null: false
    end
  end
end
