import com.ib.client.Contract

class Signal implements Observer {
  def signals = new Stack()
  def notifier = new SignalNotifier()
  Random rand = new Random()
  final int CHANCE = 100 * 250 / (391.0 * 12)
  def type

  Signal() {
    notifier.addObserver(new ObservablePosition().observer)
  }

  def add(signal) {
    signals << (signal ? 'LONG' : 'SHORT')

    notifier.notifyObservers()
  }

  public void update(Observable observed, Object data) {
    def nextInt = rand.nextInt(100)
//    if (nextInt < CHANCE) {
      add(type = !type)
//    }
  }

  private class SignalNotifier extends Observable {
    public void notifyObservers() {
      setChanged()
      super.notifyObservers(signals.peek())
    }
  }
}

class ObservablePosition {
  def positions = new Stack()
  def notifier = new PositionNotifier()
  def observer = new PositionObserver()

  ObservablePosition() {
    notifier.addObserver(new Order().observer)
  }


  def add(position) {
    positions << position
    if (positions.size() > 1)
      positions.remove(0)

    notifier.notifyObservers()
  }

  private class PositionObserver implements Observer {
    public void update(Observable ob, Object data) {
      IBUtils.gateway.client_socket.reqAccountUpdates(true, '')

      if (IBUtils.getBalance())
        add([Math.floor(IBUtils.getBalance() * 30) / 100, data == 'LONG' ? 'BUY' : 'SELL'])
    }
  }

  private class PositionNotifier extends Observable {
    public void notifyObservers() {
      setChanged()
      super.notifyObservers(positions.peek())
    }
  }
}

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

market_data = new MarketData()
signal = new Signal()
market_data.notifier.addObserver(signal)

market_data.add(['intl': 12.34])
