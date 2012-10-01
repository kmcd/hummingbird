import com.ib.client.Contract

class Order {
  def orders = []
  def notifier = new OrderNotifier()
  def observer = new OrderObserver()
  def contract = new Contract()

  Order() {
    contract.m_symbol = "QQQ"
    contract.m_exchange = "ARCA"
    contract.m_secType = "STK"

    def id = System.currentTimeMillis() as int
    IBUtils.gateway.client_socket.reqMktData(id, contract, "100", false)
  }

  def add(order) {
    orders << order
    notifier.notifyObservers()
  }

  private class OrderObserver implements Observer {
    public void update(Observable ob, Object data) {
      if (!IBUtils.gateway.liveOrders.isEmpty())
        return

      def order = new com.ib.client.Order()
      order.m_action = 'BUY'
      order.m_totalQuantity = 100
      order.m_orderType = 'STPLMT'
      order.m_tif = 'GTD'

      order.m_lmtPrice = Math.round(IBUtils.ticker * 103) / 100 as double
      order.m_auxPrice = Math.round(IBUtils.ticker * 97) / 100 as double

      if (order.m_lmtPrice == 0 || order.m_lmtPrice > IBUtils.balance * 0.30)
        return

      println("order.m_lmtPrice = " + order.m_lmtPrice);
      println("order.m_auxPrice = " + order.m_auxPrice);

      def orderId = System.currentTimeMillis() as int

      def calendar = Calendar.instance
      calendar.add(Calendar.SECOND, 65)
      order.m_goodTillDate = calendar.format("yyyyMMdd HH:mm:ss")

      IBUtils.gateway.client_socket.placeOrder(orderId, contract, order)
    }
  }

  private class OrderNotifier extends Observable {
    public void notifyObservers() {
      setChanged()
      super.notifyObservers()
    }
  }
}
