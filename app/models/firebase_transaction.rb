class FirebaseTransaction < FirebaseBase
  belongs_to :stock

  # Do not put any attrs that are also in the belongs_to or has_many
  attr_accessor :buy, :open, :profit_loss_per_share, :quantity, :sell, :symbol, :total_buy_price, :total_profit_loss, :total_sell_price
end
