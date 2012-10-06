require 'order_request'

class Order
  attr_reader :contract, :ib_id, :contract, :ib_order
  
  def self.all
    gateway = Gateway.new
    orders = gateway.client_socket.reqAllOpenOrders
    gateway.disconnect
    orders
  end
  
  def initialize(args={})
    @contract = Stock.new(args[:ticker]).contract
    @ib_order = com.ib.client.Order.new
    ib_order.m_action = args[:action]
    ib_order.m_totalQuantity = args[:quantity]
    ib_order.m_lmtPrice = args[:price]
    ib_order.m_auxPrice = args[:stop]
    ib_order.m_ocaGroup = args[:oca_group] || ''
    ib_order.m_ocaType = 1
    ib_order.m_orderType = args[:type] || 'LMT'
    ib_order.m_tif = 'IOC'
    ib_order.m_allOrNone = true
    ib_order.m_goodAfterTime = args[:activate_at]
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