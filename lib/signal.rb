require 'knn'

module Hummingbird
  class Signal # PositionSignal
    include Observable
    
    def update(market_data)
      puts "[SIGNAL] #{market_data}"
    end
  end
end
