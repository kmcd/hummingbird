class Signal implements Observer {
  def signals = new Stack()
  def notifier = new SignalNotifier()
  Random rand = new Random()

  Signal() {
    notifier.addObserver(new ObserverPosition().observer)
  }

  def add(signal) {
    def nextInt = rand.nextInt(100)
//    if (nextInt < 16) {
      signals << signal
      notifier.notifyObservers()
//    }
  }

  public void update(Observable observed, Object data) {
    add(data)
  }

  private class SignalNotifier extends Observable {
    public void notifyObservers() {
      setChanged()
      super.notifyObservers(signals.peek())
    }
  }
}

class ObserverPosition {
  def positions = new Stack()
  def notifier = new PositionNotifier()
  def observer = new PositionObserver()

  def add(position) {
    positions << position
    while (positions.size() > 1)
      positions.remove(0)
    notifier.notifyObservers()
  }

  private class PositionObserver implements Observer {
    public void update(Observable ob, Object data) {
      System.out.println("ObserverPosition\$PositionObserver.update");
      add(data)

      IBUtils.gateway.client_socket.reqAccountUpdates(true, '')

      println "${IBUtils.getBalance() / 3}"
    }
  }

  private class PositionNotifier extends Observable {
    public void notifyObservers() {
      setChanged()
      super.notifyObservers()
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
    public void update(Observable ob, Object a) {}
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
