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
  
  test "first last items not available when not full" do
    assert_nil @deck.first_last
    9.times { @deck.add 0 }
    assert_nil @deck.first_last
  end
  
  test "first last items available when full" do
    10.times { @deck.add 0 }
    assert_equal [0,0], @deck.first_last
  end
end
