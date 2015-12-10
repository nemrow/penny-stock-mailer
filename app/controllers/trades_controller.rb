class TradesController < ApplicationController
  def index
    @open_stocks = Transaction.all_open.order(:updated_at)
    @closed_stocks = Transaction.all_closed.order(:updated_at)

    user = User.first
    @cash = user.cash
    @stocks = Transaction.all_open.sum(:current_price) * 100
    @cash_plus_stocks = @cash + @stocks
  end
end
