class FirebaseStock < FirebaseBase
  has_many :transactions

  attr_accessor :current_price, :name, :plots, :symbol, :timestamp
end
