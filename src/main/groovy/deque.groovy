import groovy.util.logging.Log

@Log
class MarketData {
  final static MAX_SIZE = 4 // (15 secs slots)
  final static MAX_COMPONENTS = 10
  private deque = [] as ArrayDeque

  def add(stock, price) {
    if (queue_full()) {
      log.info "Deque is full. Removing ${deque.removeFirst()}"
    }
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

  String toString() {
    return "MarketData${deque}"
  }

  // notify observers when Q full & all n components available
}