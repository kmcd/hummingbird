require 'knn'

# TODO: rename to PositionSignal
module Hummingbird
  class Signal
    include Observable
    attr_reader :knn
    
    def initialize(historic_data)
      @knn = Knn.new Classifer.new(historic_data).trained_examples
    end
    
    def update(market_data)
      changed
      notify_observers knn.classify example_from(market_data)
    end
    
    def example_from(market_data)
      market_data.realtime_data.to_a.map do |ticker, deck|
        { ticker => deck.percent_change }
      end.first
    end
  end
end
