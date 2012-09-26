class ObserverMarketData {
  def notifier = new MarketDataNotifier()
  def data = new MarketData()

  def add(stock, price) {
    data.add(stock, price)
    notifier.notifyObservers(data)
  }

  private class MarketDataNotifier extends Observable {
    public void notifyObservers(data) {
      setChanged()
      super.notifyObservers(data)
    }
  }
}

class Signal implements Observer {
  def signals = [] // as Deque
  def notifier = new SignalNotifier()

  def add(signal) {
    signals << signal
    notifier.notifyObservers()
  }

  public void update(Observable observed, Object data) {
    signals << data
    log.info signals
  }

  private class SignalNotifier extends Observable {
    public void notifyObservers() {
      setChanged()
      super.notifyObservers()
    }
  }
}

class ObserverPosition {
  def positions = []
  def notifier = new PositionNotifier()
  def observer = new PositionObserver()

  def add(position) {
    positions << position
    notifier.notifyObservers()
  }

  private class PositionObserver implements Observer {
    public void update(Observable ob, Object a) {}
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
