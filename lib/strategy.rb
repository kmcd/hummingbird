require 'observable'
require 'market_data'
require 'entry_signal'
require 'position'
require 'order_placement'

class Strategy
  attr_reader :tradeable, :components
    
  def initialize(tradeable, components)
    @tradeable, @components = tradeable, components
    ensure_market_data_available
    setup_queue_flow
  end
  
  def market_data
    @market_data ||= MarketData.new tradeable, components
  end
  
  def signal
    @signal ||= EntrySignal.new tradeable, market_data.historic_data
  end
  
  def position
    @position ||= Position.new
  end
  
  def order_placement
    @order_placement ||= OrderPlacement.new tradeable, market_data.realtime
  end
  
  def trade(start=true)
    market_data.realtime_polling start
  end
  
  def setup_queue_flow
    market_data.add_observer signal
    signal.add_observer position
    position.add_observer order_placement
  end
  
  def ensure_market_data_available
    market_data
    print "Waiting for market data "
    until market_data.available?
      # print '.'
      puts market_data.historic_data.keys.inspect
      puts market_data.realtime_data.keys.inspect
      sleep 1
    end
    puts
  end
end