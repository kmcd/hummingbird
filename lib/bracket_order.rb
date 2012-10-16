class BracketOrder
  attr_reader :entry, :quantity, :ticker, :gateway, :current_ask
  
  def initialize(position, ticker, gateway, current_ask)
    @entry, @quantity, @ticker, @gateway, @current_ask = position.entry,
      position.size, ticker, gateway, current_ask
  end
  
  def place_orders
    return if shares < 1
    bracket_orders.each &:place
  end
  
  def bracket_orders
    [ entry_order, profit_target_exit, stop_loss_exit, expiry_exit ]
  end
  
  def long?
    entry.to_s =~ /long/i
  end
  
  def order(order_args={})
    args = { :ticker => ticker, :quantity => shares, :price => current_ask,
      :gateway => gateway, :expire_at => time_to_fill }.merge! order_args
    entry = order_args[:type].nil?
    if entry
      long? ? Order.buy(args) : Order.sell(args)
    else
      args.merge!({:parent_id => entry_order.order_id, 
        :oca_group => oca_group})
      long? ? Order.sell(args)  : Order.buy(args)
    end
  end
  
  def entry_order
    @entry_order ||= order :price => current_ask
  end
  
  def profit_target_exit
    order :type => 'STPLMT', :stop => trigger, :price => profit_target
  end
  
  def stop_loss_exit
    order :type => 'STPLMT', :stop => trigger, :price => stop_loss
  end
  
  def expiry_exit
    order :type => 'MKT', :activate_at => expire_at
  end
  
  def oca_group
    @oca_group ||= [ ticker, entry.to_s.downcase, Time.now.to_i ].join '_'
  end
  
  def trigger
    long? ? -0.01 : +0.01
  end
  
  def shares
    (quantity / current_ask).round
  end
  
  def profit_target
    current_ask + long? ? 0.05 : -0.05
  end # TODO: dry up with Classifier
  
  def stop_loss
    current_ask + long? ? -0.02 : 0.02
  end
  
  def time_to_fill
    # 5.seconds.from_now.ib_format
  end
  
  def expire_at
    1.minute.from_now.ib_format
  end
end

class Time
  def ib_format
    self.strftime "%Y%m%d %H:%M:%S"
  end
end
