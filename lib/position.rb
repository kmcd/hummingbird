class Position
  attr_accessor :entry
  include Observable
  
  def update(signal)
    puts "[POSITION] #{signal.current}"
    entry = signal.current
    changed
    notify_observers self
  end
  
  def viable?
    # return unless Account.day_tradeable?
    # signal.accuracy >= 60 && daily_drawdown_ok?
  end
  
  def size
    10_000 # fixed for evaluation
  end
end
