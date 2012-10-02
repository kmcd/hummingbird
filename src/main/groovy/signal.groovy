import com.ib.client.Contract

class Signal implements Observer {
  def signals = new Stack()
  def notifier = new SignalNotifier()
  Random rand = new Random()
  def type

  Signal() { notifier.addObserver(new Position().observer) }

  def add(signal) {
    signals << (signal ? 'LONG' : 'SHORT')
    notifier.notifyObservers()
  }

  public void update(observed, Object data) {}

  class SignalNotifier extends Observable {
    def notifyObservers() {
      setChanged()
      super.notifyObservers(signals.peek())
    }
  }
}