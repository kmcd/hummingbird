require 'observable'
require 'market_data'
require 'entry_signal'
require 'position'
require 'order_placement'
NDX_10 = %w[ AAPL MSFT GOOG ORCL INTC AMZN QCOM CSCO CMCSA AMGN ]

class Strategy
  attr_reader :market_data, :signal, :position, :order
  
  def initialize(tradeable='SQQQ', components=NDX_10)
    @market_data = MarketData.new tradeable, components
    @signal = EntrySignal.new tradeable, market_data.historic_data
    @position = Position.new
    @order = OrderPlacement.new tradeable, market_data.realtime
    setup_queue_flow
  end
  
  def trade(start=true)
    market_data.realtime_polling start
  end
  
  def setup_queue_flow
    market_data.add_observer signal
    signal.add_observer position
    position.add_observer order
  end
end