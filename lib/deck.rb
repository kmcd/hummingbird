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
  
  def full?
    size == max
  end
  
  def remove_first_item
    pop
  end
  
  def add_to_back(bar)
    insert 0, bar
  end
  
  def percent_change
    return unless full?
    change = ( current_close / previous_close ) - 1
    change.nan? ? 0.0 : change.to_f
  end
  
  def current_close
    BigDecimal.new first[:close].to_s
  end
  
  def previous_close
    BigDecimal.new last[:close].to_s
  end
end
