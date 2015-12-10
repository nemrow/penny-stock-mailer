class Transaction < ActiveRecord::Base
  scope :all_open, -> { where(open: true) }
  scope :all_closed, -> { where(open: false) }

  def class_status
    if total_profit_loss < 0
      "danger"
    else
      "success"
    end
  end
end
