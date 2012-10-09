require 'redis'

class Order
  attr_reader :contract, :ib_id, :contract, :ib_order, :gateway
  
  def initialize(args={})
    @gateway = args[:gateway]
    @contract = Stock.new(args[:ticker]).contract
    @ib_order = com.ib.client.Order.new
    ib_order.m_action = args[:action]
    ib_order.m_totalQuantity = args[:quantity]
    ib_order.m_lmtPrice = args[:price]
    ib_order.m_auxPrice = args[:stop] || 0
    ib_order.m_ocaGroup = args[:oca_group] || ''
    ib_order.m_ocaType = 1
    ib_order.m_orderType = args[:type] || 'LMT'
    ib_order.m_tif = args[:expire_at] ? 'GTD' : 'IOC'
    ib_order.m_allOrNone = true
    ib_order.m_goodAfterTime = args[:activate_at] || ''
    ib_order.m_goodTillDate = args[:expire_at] || ''
  end
  
  def place
    gateway.placeOrder order_id, contract, ib_order
  end
  
  def cancel
    gateway.cancelOrder order_id
  end
  
  def order_id
    @order_id ||= Redis.new.incr :next_order_id
  end
end