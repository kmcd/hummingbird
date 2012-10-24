require 'bracket_order'

class OrderPlacement < Gateway
  attr_reader :ticker, :realtime_data
  attr_accessor :bracket_order
  
  def initialize(ticker, realtime_data)
    @ticker, @realtime_data = ticker, realtime_data
    super()
  end
  
  def update(position)
    return if slot_taken?
    self.bracket_order = BracketOrder.new position, ticker, self, current_ask
    bracket_order.place_orders
  end
  
  def current_ask
    realtime_data.current_ask ticker # 5s old - could miss the market
  end
  
  def slot_taken?
    return unless bracket_order
    entry_order_filled? && exit_order_pending?
  end
  
  def orderStatus(orderId, status, filled, remaining, avgFillPrice, permId, 
      parentId, lastFillPrice, clientId, whyHeld)
    update_order_status orderId, status
  end
  
  def entry_order_filled?
    bracket_order.entry_order.filled?
  end
  
  def exit_order_pending?
    bracket_order.exit_orders.any? &:pending?
  end
  
  def update_order_status(order_id, status)
    return unless order = bracket_order.find_order(order_id)
    order.status = status
  end
end
