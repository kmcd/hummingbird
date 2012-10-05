require 'helper'
require 'deck'

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new 10
  end
  
  test "max size" do
    10.times { @deck.add 0 }
    @deck.add 1
    assert_equal [1, [0]*9].flatten, @deck.queue
  end
  
  test "add to back of queue" do
    @deck.add 0
    assert_equal [0], @deck.queue
    @deck.add 1
    assert_equal [1,0], @deck.queue
  end
  
  test "remove from front of queue" do
    @deck.add 0
    @deck.add 1
    assert_equal 0, @deck.remove_first_item
    assert_equal [1], @deck.queue
  end
  
  test "percent change not available when not full" do
    assert_nil @deck.percent_change
    9.times { @deck.add 0 }
    assert_nil @deck.percent_change
  end
  
  test "percent change available when full" do
    10.times { @deck.add 1 }
    assert_equal 0.0, @deck.percent_change
  end
  
  test "calculate percentage change close" do
    9.times { @deck.add( {:close => 68.14 } ) }
    @deck.add( {:close => 68.18 } )
    assert_in_delta 0.0005870, @deck.percent_change, 0.00001
  end
end
