import com.ib.client.Contract

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

