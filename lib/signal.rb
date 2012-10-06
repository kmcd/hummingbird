require 'knn'

class EntrySignal
  include Observable
  attr_reader :knn
  attr_accessor :current
  
  def initialize(historic_data)
    @knn = Knn.new Classifer.new(historic_data).trained_examples
  end
  
  def update(market_data)
    return unless self.currexnt = knn.classify(example_from(market_data))
    changed
    notify_observers self
  end
  
  def example_from(market_data)
    market_data.realtime_data.to_a.map do |ticker, deck|
      { ticker => deck.percent_change }
    end.inject({}) {|hash, ticker| hash.merge!(ticker) }
  end
end
