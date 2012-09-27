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
    signals << (signal ? 'long' : 'short')

    println signals

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
    requestBalance()
    notifier.addObserver(new Order().observer)
  }

  private def requestBalance() {
    IBUtils.gateway.client_socket.reqAccountUpdates(true, '')
  }

  def add(position) {
    positions << position
    if (positions.size() > 1)
      positions.remove(0)

    notifier.notifyObservers()
  }

  private class PositionObserver implements Observer {
    public void update(Observable ob, Object data) {
      requestBalance()

      if (IBUtils.getBalance())
        add([Math.floor(IBUtils.getBalance() * 30) / 100, data == 'long' ? 'buy' : 'sell'])
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

  def add(order) {
    orders << order
    notifier.notifyObservers()
  }

  private class OrderObserver implements Observer {
    public void update(Observable ob, Object a) {
      IBUtils.gateway.client_socket.placeOrder(System.currentTimeMillis() as int, new Stock('QQQ').contract, )
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
