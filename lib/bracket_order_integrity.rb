# TODO: shouldnt need this now if parent_order_id works correctly
class BracketOrderIntegrity
  attr_reader :order_id, :status, :filled, :parent_order_id
  
  def initialize(order_id, status, filled, parent_order_id)
    @order_id, @status, @filled, @parent_order_id = order_id, status,
      filled, parent_order_id
  end
  
  def maintain
    cancel_exit_orders if entry_missed?
  end
  
  def entry_missed?
    entry_order? && status =~ /(cancelled)/i
  end
  
  def entry_order?
    parent_order_id.nil?
  end
  
  def cancel_exit_orders
    entry_order_id = entry_order? ? order_id : parent_order_id
    LiveOrder.cancel_exit_orders entry_order_id
  end
end
