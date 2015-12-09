class Transaction < ActiveRecord::Base
  scope :all_open, -> { where(open: true) }
end
