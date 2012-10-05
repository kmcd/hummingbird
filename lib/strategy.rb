require 'observable'
require 'market_data'
require 'signal'
require 'position'
require 'order_placement'

class Strategy
  attr_reader :market_data, :signal, :position, :order
  
  def initialize
    @market_data = MarketData.new
    wait_for market_data.historic_data
    @signal = Hummingbird::Signal.new market_data.historic_data
    @position = Position.new
    @order = OrderPlacement.new
    setup_queue_flow
  end
  
  def trade
    market_data.realtime_polling
  end
  
  def wait_for(historic_data)
    print "Waiting for historic data "
    while historic_data.keys.size < 11
      print '.'
      sleep 1
    end
  end
  
  def setup_queue_flow
    market_data.add_observer signal
    signal.add_observer position
    position.add_observer order
  end
end