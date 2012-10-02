import com.ib.client.Contract

class Position {
  def positions = new Stack()
  def notifier = new PositionNotifier()
  def observer = new PositionObserver()

  Position() {
    notifier.addObserver(new Order().observer)
  }

  def add(position) {
    positions << position
    if (positions.size() > 1) positions.remove(0)

    notifier.notifyObservers()
  }

  class PositionObserver implements Observer {
    public void update(Observable ob, Object data) {
      IBUtils.gateway.client_socket.reqAccountUpdates(true, '')

      if (IBUtils.getBalance())
        add([Math.floor(IBUtils.getBalance() * 30) / 100, data == 'LONG' ? 'BUY' : 'SELL'])
    }
  }

  class PositionNotifier extends Observable {
    def notifyObservers() {
      setChanged()
      super.notifyObservers(positions.peek())
    }
  }
}

