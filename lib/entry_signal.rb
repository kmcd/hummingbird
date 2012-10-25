require 'knn'
require 'classifer'

class EntrySignal
  include Observable
  attr_reader :knn
  attr_accessor :current
  
  def initialize(ticker, historic_data)
    @knn = KNearestNeighbours.new Classifer.new(ticker, historic_data).
      trained_examples
  end
  
  def update(market_data)
    publish if self.current = knn.classify(example_from(market_data))
  end
  
  def example_from(market_data)
    market_data.realtime_data.to_a.map do |ticker, deck|
      { ticker => deck.percent_change }
    end.inject({}) {|hash, ticker| hash.merge!(ticker) }
  end
end
