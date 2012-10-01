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