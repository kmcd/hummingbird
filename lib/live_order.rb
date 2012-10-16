class LiveOrder < Gateway
  def self.create(order)
    repository.sadd "order:entry:#{order.entry_order_id}", order.order_id
  end
  
  def self.cancel_exit_orders(entry_order_id)
    gateway = new
    exit_orders(entry_order_id).each {|order_id| gateway.cancel order_id }
  end
  
  def self.exit_orders(entry_order_id)
    repository.smembers "order:entry:#{entry_order_id}"
  end
  
  def self.repository
    Redis.new
  end
  
  def cancel(order_id)
    cancelOrder order_id
  end
end
