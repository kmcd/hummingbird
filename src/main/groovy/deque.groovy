class MarketData {
  final static MAX_SIZE = 4 // (15 secs slots)
  final static MAX_COMPONENTS = 10
  private deque = [] as ArrayDeque

  def add(stock, price) {
    if (queue_full()) { deque.removeFirst() }
    if (component_slot_available()) { add_component(stock, price); return }
    deque.add(["${stock}": price])
  }

  def add_component(stock, price) {
    deque.peekLast()["${stock}"] = price
  }

  def queue_full() {
    deque.size() == MAX_SIZE
  }

  def component_slot_available() {
    deque.peekLast() && deque.peekLast().size() < MAX_COMPONENTS
  }

  // notify observers when Q full & all n components available
}