require 'gateway'

# TODO: keep connection open (Singleton ?) instead of (dis)connecting
class OrderRequest < Gateway
  attr_reader :next_order_id
    
  def next_available_id
    return next_order_id if next_order_id
    connect
    request_next_order_id
    sleep 0.5
    disconnect
    next_order_id
  end
  
  def request_next_order_id
    client_socket.reqIds 1
  end
  
  def nextValidId(next_order_id)
    puts next_order_id
    @next_order_id = next_order_id
  end
end
