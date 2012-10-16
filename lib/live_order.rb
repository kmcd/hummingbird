class LiveOrder < Gateway
  class << self
    def create(order)
      repository.sadd entry(order), order.order_id
    end
    
    def cancel_exit_orders(entry_order_id)
      gateway = new
      exit_orders(entry_order_id).each {|order_id| gateway.cancel order_id }
      repository.del entry(order)
    end
    
    def exit_orders(entry_order_id)
      repository.smembers entry_order
    end
    
    def repository
      @redis ||= Redis.new
    end
    
    def entry(order)
      "order:entry:#{order.entry_order_id}"
    end
  end
  
  def cancel(order_id)
    cancelOrder order_id
  end
end
