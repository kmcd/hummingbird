class Order
  attr_reader :contract, :ib_id, :contract, :ib_order, :gateway, :order_id
  attr_accessor :status
  
  def self.buy(args={})
    new args.merge!(:action => 'BUY')
  end
  
  def self.sell(args={})
    new args.merge!(:action => 'SELL')
  end
  
  def initialize(args={})
    @gateway = args[:gateway]
    @contract = Stock.new(args[:ticker]).contract
    @ib_order = com.ib.client.Order.new
    ib_order.m_orderId = next_order_id
    ib_order.m_clientId = gateway.client_id.to_i
    ib_order.m_action = args[:action]
    ib_order.m_totalQuantity = args[:quantity]
    ib_order.m_lmtPrice = args[:price]
    ib_order.m_auxPrice = args[:stop] || 0
    ib_order.m_ocaGroup = args[:oca_group] || ''
    ib_order.m_ocaType = 1
    ib_order.m_orderType = args[:type] || 'LMT'
    ib_order.m_tif = args[:expire_at] ? 'GTD' : 'DAY'
    ib_order.m_allOrNone = true
    ib_order.m_goodAfterTime = args[:activate_at] if args[:activate_at]
    ib_order.m_goodTillDate = args[:expire_at] if args[:expire_at]
    ib_order.m_parentId = args[:parent_id]
    ib_order.m_transmit = args[:transmit].nil? ? true : args[:transmit]
  end
  
  def place
    gateway.placeOrder order_id, contract, ib_order
  end
  
  def next_order_id
    Redis.new.incr :next_order_id
  end
  
  def order_id
    ib_order.m_orderId
  end
  
  def entry_order_id
    ib_order.m_parentId
  end
  
  def filled?
    status =~ /filled/i
  end
  
  def pending?
    status =~ /(submitted|pendingsubmit)/i
  end
end