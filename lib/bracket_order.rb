class BracketOrder
  attr_reader :entry, :quantity, :ticker, :gateway, :current_ask
  
  def initialize(position, ticker, gateway, current_ask)
    @entry, @quantity, @ticker, @gateway, @current_ask = position.entry,
      position.size, ticker, gateway, current_ask
  end
  
  def place_orders
    return if shares < 1
    
    [ entry_order,
      order(:type => 'LMT',     :price => profit_target(0.05)),
      order(:type => 'LMT',     :price => profit_target(0.04), :activate_at => 36.seconds.from_now.ib_format),
      order(:type => 'LMT',     :price => profit_target(0.03), :activate_at => 52.seconds.from_now.ib_format),
      order(:type => 'LMT',     :price => profit_target(0.02), :activate_at => 56.seconds.from_now.ib_format),
      order(:type => 'STPLMT',  :price => stop_loss(0.02), :stop => stop_loss(0.02)),
      order(:type => 'STP',     :stop =>  stop_loss(0.03)),
      order(:type => 'MKT',     :activate_at => 1.minute.from_now.ib_format, transmit => true),
    ].each &:place
  end
  
  def long?
    entry.to_s.match /long/i
  end
  
  def order(order_args={})
    args = { :ticker => ticker, :quantity => shares, :price => current_ask,
      :gateway => gateway, :transmit => false }.merge! order_args
    
    exit_order = !order_args[:type].blank?
    if exit_order
      args.merge!({:parent_id => entry_order.order_id, :oca_group => oca_group})
      long? ? Order.sell(args) : Order.buy(args)
    else
      long? ? Order.buy(args) : Order.sell(args)
    end
  end
  
  def entry_order
    @entry_order ||= order :price => current_ask, :expire_at => 10.seconds.
      from_now.ib_format
  end
  
  def oca_group
    @oca_group ||= [ ticker, entry.to_s.downcase, Time.now.to_i.to_s ].
      join '_'
  end
  
  def shares
    (quantity / current_ask).round
  end
  
  def profit_target(target)
    current_bid + (long? ? target : -target)
  end 
  
  def stop_loss(target)
    current_bid + (long? ? -target : target)
  end
  
  def current_bid
    current_ask - 0.01 # assuming tight spread
  end
end

class Time
  def ib_format
    self.strftime "%Y%m%d %H:%M:%S"
  end
end
