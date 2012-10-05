class Deck
  extend Forwardable
  attr_reader :max, :queue
  def_delegators :queue, :insert, :first, :last, :size, :pop
  
  def initialize(size)
    @max, @queue = size, []
  end
  
  def add(bar)
    remove_first_item if full?
    add_to_back bar
  end
  
  def first_last
    return unless full?
    [first, last]
  end
  
  def full?
    size == max
  end
  
  def remove_first_item
    pop
  end
  
  def add_to_back(bar)
    insert 0, bar
  end
end
