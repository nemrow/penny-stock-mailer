class Stock < ActiveRecord::Base
  before_create :add_firebase_id

  def add_firebase_id
    firebase_object = firebase_base_client.push("stocks", {
      symbol: self.symbol,
      name: self.name
    })
    self.firebase_id = firebase_object.body["name"]
  end

  private

  def firebase_base_client
    Firebase::Client.new("https://penny-stock.firebaseio.com/")
  end
end
