class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :stock
      t.decimal :buy, :precision => 15, :scale => 10
      t.decimal :total_buy_price, :precision => 15, :scale => 10
      t.decimal :sell, :precision => 15, :scale => 10
      t.decimal :total_sell_price, :precision => 15, :scale => 10
      t.integer :quantity
      t.boolean :open
      t.decimal :profit_loss_per_share, :precision => 15, :scale => 10
      t.decimal :total_profit_loss, :precision => 15, :scale => 10
      t.decimal :current_price, :precision => 15, :scale => 10

      t.timestamps null: false
    end
  end
end
