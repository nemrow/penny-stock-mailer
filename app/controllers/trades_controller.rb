class TradesController < ApplicationController
  def index
    @open_stocks = Transaction.all_open
    @closed_stocks = Transaction.all_closed

    user = User.first
    @cash = user.cash
    @cash_plus_stocks = Transaction.all_open.sum(:current_price)
  end
end
