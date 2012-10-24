require 'observable'
require 'market_data'
require 'entry_signal'
require 'position'
require 'order_placement'

class Strategy
  attr_reader :market_data, :signal, :position, :order_placement
    
  def initialize(tradeable, components)
    @market_data = MarketData.new tradeable, components
    ensure_market_data_available
    @signal = EntrySignal.new tradeable, market_data.historic_data
    @position = Position.new
    @order_placement = OrderPlacement.new tradeable, market_data.realtime
    setup_queue_flow
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
    print "Waiting for market data "
    until market_data.available?
      puts market_data.historic_data.keys.inspect
      puts market_data.realtime_data.keys.inspect
      # print '.'
      sleep 1
    end
    puts
  end
end