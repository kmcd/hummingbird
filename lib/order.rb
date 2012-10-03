class Order
  attr_reader :contract, :ib_id, :contract, :ib_order
  
  def self.all
    gateway = Gateway.new
    orders = gateway.client_socket.reqAllOpenOrders
    gateway.disconnect
    orders
  end
  
  def initialize(ticker, action, quantity, price, type='LMT', duration='IOC')
    @contract = Stock.new(ticker).contract
    @ib_order = com.ib.client.Order.new
    ib_order.m_action = action
    ib_order.m_totalQuantity = quantity
    ib_order.m_orderType = type
    ib_order.m_tif = duration
    ib_order.m_allOrNone = true
    ib_order.m_lmtPrice = price if type == 'LMT'
  end
  
  def place
    gateway.placeOrder order_id, contract, ib_order
  end
  
  def cancel
    gateway.cancelOrder order_id
  end
  
  def order_id
    @order_id ||= OrderRequest.new.next_available_id
  end
  
  def gateway
    @gateway ||= Gateway.new
  end
end

class OrderRequest < Gateway
  attr_reader :next_order_id
    
  def next_available_id
    return next_order_id if next_order_id
    request_next_order_id
    sleep 0.5
    disconnect
    next_order_id
  end
  
  def request_next_order_id
    client_socket.reqIds 2
  end
  
  def nextValidId(next_order_id)
    @next_order_id = next_order_id
  end
end