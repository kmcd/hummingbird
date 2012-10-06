require 'order'
require 'order_request'

class OrderPlacement
  extend Forwardable
  def_delegator :realtime_data, :current_ask
  attr_reader :ticker, :realtime_data
  
  def initialize(ticker, realtime_data)
    @ticker, @realtime_data = ticker, realtime_data
  end
  
  def update(position)
    puts "[ORDER PLACEMENT] type:#{position.entry} quantity:#{position.size}"
    place position.entry, position.size
  end
  
  def place(type, quantity)
    raise ArgumentError unless type
    create type, quantity
    orders.each &:place
    cancel unless all_filled?
  end
  
  def all_filled?
    true # TODO: query execution report
  end
  
  def cancel
    orders.each &:cancel
  end
  
  def create(type, quantity)
    long(quantity) if type.to_sym == :long
    short quantity
  end
  
  def long(quantity)
    orders << Order.new(:action => 'BUY', :ticker => ticker,
      :quantity => quantity, :price => current_ask)
    
    orders << Order.new(:action => 'SELL', :type => 'STPLMT', 
      :ticker => ticker, :quantity => quantity, :price => profit_target, 
      :stop => profit_target - 0.01, :oca_group => 'qqq_long')
    
    orders << Order.new(:action => 'SELL', :type => 'STPLMT', 
      :ticker => ticker, :quantity => quantity, :price => stop_loss, 
      :stop => profit_target + 0.01, :oca_group => 'qqq_long')
    
    orders << Order.new(:action => 'SELL', :type => 'MKT', 
      :ticker => ticker, :quantity => quantity, :activate_at => expiration,
      :oca_group => 'qqq_long')
  end
  
  def short(quantity)
    orders << Order.new(:action => 'SELL', :ticker => ticker,
      :quantity => quantity, :price => current_ask)
    
    orders << Order.new(:action => 'BUY', :type => 'STPLMT', 
      :ticker => ticker, :quantity => quantity, 
      :price => profit_target(:short),  :stop => profit_target + 0.01, 
      :oca_group => 'qqq_long')
    
    orders << Order.new(:action => 'BUY', :type => 'STPLMT',
      :ticker => ticker, :quantity => quantity, :price => stop_loss(:short),
      :stop => profit_target - 0.01, :oca_group => 'qqq_long')
    
    orders << Order.new(:action => 'BUY', :type => 'MKT', :ticker => ticker,
      :quantity => quantity, :activate_at => expiration,
      :oca_group => 'qqq_long')
  end
  
  def profit_target(short=false)
    return current_ask - 0.05 if short
    current_ask + 0.05
  end
  
  def stop_loss(short=false)
    return current_ask + 0.02 if short
    current_ask - 0.02
  end
  
  def expiration
    1.minute.from_now.strftime "%Y%m%d %H:%M:%S"
    # TODO: dry up with HistoricData
  end
  
  def current_ask
    68.98
  end
  
  def orders
    @orders ||= []
  end
end
