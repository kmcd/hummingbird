require 'order'

class OrderPlacement < Gateway
  attr_reader :ticker, :realtime_data, :next_order_id
  
  def initialize(ticker, realtime_data)
    @ticker, @realtime_data = ticker, realtime_data
    super()
  end
  
  def update(position)
    raise ArgumentError unless position.type
    return unless orders.empty?
    create position.type, position.size
    orders.each &:place
  end
  
  def create(type, quantity)
    long(quantity) if type.to_sym == :long
    short quantity
  end
  
  def long(quantity)
    oca_group = "#{ticker}_long_#{Time.now.to_i}"
    
    orders << Order.new(:action => 'BUY', :ticker => ticker,
      :quantity => quantity, :price => current_ask, :gateway => self,
      :oca_group => oca_group, :expire_at => time_to_fill)
    
    orders << Order.new(:action => 'SELL', :type => 'STPLMT',
      :ticker => ticker, :quantity => quantity, :price => profit_target, 
      :stop => profit_target - 0.01, :oca_group => oca_group, 
      :gateway => self )
    
    orders << Order.new(:action => 'SELL', :type => 'STPLMT', 
      :ticker => ticker, :quantity => quantity, :price => stop_loss, 
      :stop => profit_target + 0.01, :oca_group => oca_group, 
      :gateway => self)
    
    orders << Order.new(:action => 'SELL', :type => 'MKT', 
      :ticker => ticker, :quantity => quantity, :oca_group => oca_group,
      :activate_at => 1.minute.from_now.strftime("%Y%m%d %H:%M:%S"),
      :gateway => self)
  end
  
  def short(quantity)
    oca_group = "#{ticker}_short_#{Time.now.to_i}"
    
    orders << Order.new(:action => 'SELL', :ticker => ticker,
      :quantity => quantity, :price => current_ask, :gateway => self,
      :oca_group => oca_group, :expire_at => time_to_fill)
    
    orders << Order.new(:action => 'BUY', :type => 'STPLMT', 
      :ticker => ticker, :quantity => quantity, 
      :price => profit_target(:short),  :stop => profit_target + 0.01, 
      :oca_group => oca_group, :gateway => self)
    
    orders << Order.new(:action => 'BUY', :type => 'STPLMT',
      :ticker => ticker, :quantity => quantity, :price => stop_loss(:short),
      :stop => profit_target - 0.01, :oca_group => oca_group,
      :gateway => self)
    
    orders << Order.new(:action => 'BUY', :type => 'MKT', :ticker => ticker,
      :quantity => quantity, :oca_group => oca_group, :gateway => self,
      :activate_at => 1.minute.from_now.strftime("%Y%m%d %H:%M:%S"))
  end
  
  # TODO: move to OrderEntry.long(gateway)
  def profit_target(short=false)
    return current_ask - 0.05 if short
    current_ask + 0.05
  end
  
  def stop_loss(short=false)
    return current_ask + 0.02 if short
    current_ask - 0.02
  end
  
  def time_to_fill
    10.seconds.from_now.strftime "%Y%m%d %H:%M:%S"
  end
  
  def orders
    @orders ||= []
  end
  
  def current_ask
    realtime_data.current_ask ticker # FIXME: 5s old - could miss the market
  end
  
  def orderStatus(order_id, status, filled, remaining, avgFillPrice, permId,
      parentId, lastFillPrice, clientId, whyHeld)
    order = orders.find {|order| order.order_id == order_id }
    orders.each &:cancel  if status =~ /cancelled/i && order == orders.first
    orders.delete order   if status =~ /(inactive|cancelled|filled)/i
  end
end
