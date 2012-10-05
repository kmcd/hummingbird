require 'observable'
require 'market_data'
require 'signal'
require 'position'
require 'order_placement'

class Strategy
  attr_reader :market_data, :signal, :position, :order
  
  def initialize
    @market_data = MarketData.new
    @signal = Hummingbird::Signal.new
    @position = Position.new
    @order = OrderPlacement.new
    
    market_data.add_observer signal
    signal.add_observer position
    position.add_observer order
  end
  
  def trade
    # TODO: place on a background thread
  end
end