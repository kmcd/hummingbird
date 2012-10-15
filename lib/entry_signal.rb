require 'knn'

class EntrySignal
  include Observable
  attr_reader :knn
  attr_accessor :current
  
  def initialize(ticker, historic_data)
    @knn = KNearestNeighbours.new Classifer.new(ticker, historic_data).trained_examples
  end
  
  def update(market_data)
    self.current = knn.classify example_from(market_data)
    log knn, example_from(market_data)
    return unless current
    changed
    notify_observers self
  end
  
  def example_from(market_data)
    market_data.realtime_data.to_a.map do |ticker, deck|
      { ticker => deck.percent_change }
    end.inject({}) {|hash, ticker| hash.merge!(ticker) }
  end
  
  def log(knn, example)
    distances = knn.weighted_distances(example).sort_by {|_,dist| dist }
    logger.info "[ENTRY SIGNAL] #{distances.inspect}"
  end
  
  def logger
    @logger || Logger.new("./log/entry_signal_#{Date.today.to_s(:db)}.log")
  end
end
