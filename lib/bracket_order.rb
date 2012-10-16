class BracketOrder
  attr_reader :entry, :quantity, :ticker, :gateway, :current_ask
  
  def initialize(position, ticker, gateway, current_ask)
    @entry, @quantity, @ticker, @gateway, @current_ask = position.entry,
      position.size, ticker, gateway, current_ask
  end
  
  def inspect
    bracket_orders.map(&:inspect).join ' '
  end
  
  def place_orders
    return if shares < 1
    bracket_orders.each &:place
  end
  
  def bracket_orders
    [ entry_order, profit_target_exit, stop_loss_exit, expiry_exit ]
  end
  
  def long?
    entry.to_s.match /long/i
  end
  
  def order(order_args={})
    args = { :ticker => ticker, :quantity => shares, :price => current_ask,
      :gateway => gateway, :transmit => true }.merge! order_args
    
    exit_order = !order_args[:type].blank?
    if exit_order
      args.merge!({:parent_id => entry_order.order_id, 
        :oca_group => oca_group})
      long? ? Order.sell(args) : Order.buy(args)
    else
      long? ? Order.buy(args) : Order.sell(args)
    end
  end
  
  def entry_order
    @entry_order ||= order :price => current_ask, :expire_at => 10.seconds.
      from_now.ib_format
  end
  
  def profit_target_exit
    order :type => 'LMT', :price => profit_target
  end
  
  def stop_loss_exit
    # FIXME: could trade trough this price
    # Also, are you signalling intent - can you conceal order?
    order :type => 'LMT', :price => stop_loss, :transmit => true
  end
  
  def expiry_exit
    order :type => 'MKT', :activate_at => 1.minute.from_now.ib_format,
      :transmit => true
  end
  
  def oca_group
    @oca_group ||= [ ticker, entry.to_s.downcase, Time.now.to_i ].join '_'
  end
  
  def shares
    (quantity / current_ask).round
  end
  
  def profit_target
    current_ask + (long? ? 0.05 : -0.05)
  end # TODO: dry up with Classifier
  
  def stop_loss
    current_ask + (long? ? -0.02 : 0.02)
  end
end

class Time
  def ib_format
    self.strftime "%Y%m%d %H:%M:%S"
  end
end
